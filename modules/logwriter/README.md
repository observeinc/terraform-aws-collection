# Observe AWS Logwriter

This module streams CloudWatch Log Groups data to S3.

## Usage

In the simplest case, you must provide an S3 bucket where logs will be sent to,
as well as a name for the Kinesis Firehose that will be provisioned:

```hcl
resource "random_pet" "this" {}

resource "aws_s3_bucket" "this" {
    bucket = random_pet.this.id
}

module "logwriter" {
  source     = "observeinc/collection/aws//modules/logwriter"
  name       = random_pet.this.id
  bucket_arn = aws_s3_bucket.this.arn
}
```

## Statically subscribing log groups

You can add a subscription filter for an existing log group towards the Kinesis
Firehose provisioned by the logwriter module:

```hcl
resource "aws_cloudwatch_log_subscription_filter" "example" {
  name            = "observe-logs-subscription"
  log_group_name  = "my-example-log-group"
  destination_arn = module.logwriter.firehose_arn
  role_arn        = module.logwriter.destination_role_arn
}
```

## Dynamically subscribing log groups

This module embeds an optional [subscriber](../subscriber/README.md) module
to dynamically subscribe log groups to the provisioned Kinesis Firehose. You
can activate this mode by providing a set of `log_group_name_patterns` or
`log_group_name_prefixes`:

```hcl
module "logwriter" {
  source                  = "observeinc/collection/aws//modules/logwriter"
  name                    = random_pet.this.id
  bucket_arn              = aws_s3_bucket.this.arn
  log_group_name_patterns = ["*"]
  discovery_rate          = "24 hours"
}
```

> **⚠️ Behavior Change**
>
> Starting in this version, `local-exec` provisioners are **disabled by default**.
> The defaults for `wait_for_discovery_on_apply` and `cleanup_on_destroy` have
> changed to `false`.
>
> **Default behavior**: Discovery only runs via the EventBridge scheduler
> (`discovery_rate`). No AWS CLI is required on the Terraform runner. Destroy
> does not clean up subscription filters automatically.
>
> **Opt-in for apply-time discovery and destroy-time cleanup**:
> ```hcl
> wait_for_discovery_on_apply = true
> cleanup_on_destroy          = true
> ```
> This requires the AWS CLI on the Terraform runner. Provisioners activate
> automatically when either variable is set to `true`.

### Subscription lifecycle management

When dynamic subscription is enabled, the [subscriber](../subscriber/README.md)
module uses two `null_resource`s for apply-time discovery and destroy-time
cleanup. These are **disabled by default**.

When `wait_for_discovery_on_apply = true` or `cleanup_on_destroy = true`:

- **On `terraform apply`**: `null_resource.discovery_on_apply` queues a
  full-prune discovery via SQS. That reconciles subscriptions (adds and
  removes) to match current patterns and related settings. **`wait_for_discovery_on_apply`**
  controls whether Terraform **waits** and polls the queue until work
  completes; set it to `false` to enqueue only and return.

- **On `terraform destroy`**: `null_resource.cleanup_on_destroy` queues
  delete-all cleanup and waits for completion when `cleanup_on_destroy = true`.
  This removes all managed subscription filters before infrastructure teardown.

When both are `false` (default):

- Discovery runs only via the EventBridge scheduler (`discovery_rate`).
  New subscriptions are added and stale ones removed on the next scheduled run.
- No cleanup runs on destroy, see [Deleting existing subscriptions on uninstall](https://github.com/observeinc/aws-sam-apps/blob/main/docs/logwriter.md#deleting-existing-subscriptions-on-uninstall). Subscription filters pointing to the deleted
  Firehose will remain but will fail silently (no data loss, but they occupy
  a subscription filter slot on the log group).

### Prerequisites

The `local-exec` provisioners (when `wait_for_discovery_on_apply = true` or
`cleanup_on_destroy = true`) require the **AWS CLI** on the Terraform runner. The SQS queue resource policies
automatically grant the Terraform caller `sqs:SendMessage` and
`sqs:GetQueueAttributes` permissions, so no additional IAM configuration is
needed.

### Tuning for large environments

For accounts with many log groups, the following parameters control subscriber
throughput and API rate limiting:

| Parameter | Default | Description |
|---|---|---|
| `sqs_batch_size` | `5` | Messages per Lambda invocation from SQS |
| `sqs_maximum_concurrency` | `10` | Maximum concurrent subscriber Lambda invocations |
| `lambda_reserved_concurrency` | `null` | Optional hard cap on Lambda concurrency |
| `lambda_timeout` | `120` | Lambda timeout in seconds (max 900) |
| `lambda_memory_size` | `128` | Lambda memory in MB |
| `cloudwatch_api_rate_limit` | `8` | CloudWatch API requests/second per invocation |
| `cloudwatch_api_burst` | `16` | CloudWatch API burst allowance per invocation |
| `num_workers` | `1` | Concurrent workers per Lambda invocation |
| `discovery_rate` | `""` | EventBridge schedule (e.g., `"24 hours"`, `"4 hours"`) |

#### Recommended settings by scale

| Log groups | `lambda_timeout` | `lambda_memory_size` | `num_workers` | `sqs_maximum_concurrency` | `discovery_rate` | Notes |
|---|---|---|---|---|---|---|
| < 500 | `120` (default) | `128` (default) | `1` | `10` | `"24 hours"` | Defaults work well |
| 500 – 2,000 | `300` | `256` | `2` | `10` | `"12 hours"` | Increase timeout for larger scan |
| 2,000 – 5,000 | `600` | `512` | `3` | `10` | `"4 hours"` | More memory for concurrent work |
| 5,000 – 10,000 | `900` | `512` | `3` | `5` | `"4 hours"` | Reduce concurrency to avoid API throttling |
| > 10,000 | `900` | `512` | `3` | `5` | `"60 minutes"` | Consider splitting by pattern/prefix |

#### Observed timings

Tested in us-east-1 with ~3,000 log groups:

| Operation | Wall time | Configuration |
|---|---|---|
| Full discovery (EventBridge scheduled) | ~4 min | SQS fan-out with `batch_size=5`, `max_concurrency=10` |
| Full discovery (apply-time, `wait_for_discovery_on_apply=true`) | ~4 min | Same, plus polling wait |
| Cleanup on destroy (`cleanup_on_destroy=true`) | ~13 min | Single Lambda invocation processing all groups |
| Terraform apply (full stack creation + discovery) | ~3 min | Resource creation dominates |
| Terraform destroy (cleanup + resource teardown) | ~19 min | Cleanup ~13 min + resource deletion ~6 min |

**How discovery works**: Each Lambda invocation processes up to 200 log groups
(paginated in batches of 50). If more groups remain, a continuation message is
enqueued to SQS. With `sqs_maximum_concurrency=10` and `sqs_batch_size=5`,
up to 10 Lambda invocations process groups in parallel, each handling 200
groups per invocation. For 3,000 log groups, this means ~15 continuation
messages processed across multiple concurrent Lambda invocations.

**CloudWatch API limits**: The subscriber Lambda rate-limits itself to
`cloudwatch_api_rate_limit` requests/second (default 8) per invocation. With
10 concurrent invocations, the effective aggregate rate is ~80 req/s. The
[CloudWatch Logs API quotas](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/cloudwatch_limits_cwl.html)
allow 10 DescribeLogGroups and 10 DescribeSubscriptionFilters requests/second
per account by default. If you see throttling, reduce `sqs_maximum_concurrency`
or `cloudwatch_api_rate_limit`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subscriber"></a> [subscriber](#module\_subscriber) | ../subscriber | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_iam_role.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kinesis_firehose_delivery_stream.delivery_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.destination_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.destination_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_s3writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | S3 Bucket ARN to write log records to. | `string` | n/a | yes |
| <a name="input_buffering_interval"></a> [buffering\_interval](#input\_buffering\_interval) | Buffer incoming data for the specified period of time, in seconds, before<br/>delivering it to S3. | `number` | `60` | no |
| <a name="input_buffering_size"></a> [buffering\_size](#input\_buffering\_size) | Buffer incoming data to the specified size, in MiBs, before delivering it<br/>to S3. | `number` | `1` | no |
| <a name="input_cleanup_on_destroy"></a> [cleanup\_on\_destroy](#input\_cleanup\_on\_destroy) | If true, subscriber null\_resource.cleanup\_on\_destroy runs delete-all cleanup<br/>and waits on the queue during destroy. If false, skip that step. Does not<br/>affect apply-time discovery. When true, requires the AWS CLI on the Terraform runner. | `bool` | `false` | no |
| <a name="input_cloudwatch_api_burst"></a> [cloudwatch\_api\_burst](#input\_cloudwatch\_api\_burst) | Per-invocation burst size for CloudWatch API limiter in subscriber. | `number` | `null` | no |
| <a name="input_cloudwatch_api_rate_limit"></a> [cloudwatch\_api\_rate\_limit](#input\_cloudwatch\_api\_rate\_limit) | Per-invocation CloudWatch API request rate limit (requests/second) for<br/>subscriber operations. | `number` | `null` | no |
| <a name="input_cloudwatch_log_kms_key"></a> [cloudwatch\_log\_kms\_key](#input\_cloudwatch\_log\_kms\_key) | KMS key to use for cloudwatch log encryption. | `string` | `null` | no |
| <a name="input_code_uri"></a> [code\_uri](#input\_code\_uri) | S3 URI for lambda binary. If set, takes precedence over sam\_release\_version. | `string` | `""` | no |
| <a name="input_dead_letter_queue_tags"></a> [dead\_letter\_queue\_tags](#input\_dead\_letter\_queue\_tags) | Tags to add to the dead letter queue. | `map(string)` | `{}` | no |
| <a name="input_debug_endpoint"></a> [debug\_endpoint](#input\_debug\_endpoint) | Endpoint to send debugging telemetry to. Sets the OTEL\_EXPORTER\_OTLP\_ENDPOINT environment variable for the lambda function. | `string` | `null` | no |
| <a name="input_discovery_rate"></a> [discovery\_rate](#input\_discovery\_rate) | EventBridge rate expression for periodically triggering discovery. If not<br/>set, no eventbridge rules are configured. | `string` | `null` | no |
| <a name="input_exclude_log_group_name_patterns"></a> [exclude\_log\_group\_name\_patterns](#input\_exclude\_log\_group\_name\_patterns) | List of Go regular expression patterns. Any log group whose name matches<br/>a pattern is excluded from subscription, even if it matches an include<br/>pattern. Patterns are joined with "\|" into a single regex and matched<br/>using regexp.MatchString() (partial match). Exclusions take precedence<br/>over log\_group\_name\_patterns and log\_group\_name\_prefixes. | `list(string)` | `null` | no |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Subscription filter name. Existing filters that have this name as a prefix<br/>will be removed. | `string` | `null` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | CloudWatch Logs subscription filter pattern. Only log events matching this pattern are delivered to Firehose.<br/>Uses AWS CloudWatch filter pattern syntax. An empty string matches all events.<br/>See https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html | `string` | `null` | no |
| <a name="input_lambda_env_vars"></a> [lambda\_env\_vars](#input\_lambda\_env\_vars) | Environment variables to be passed into lambda. | `map(string)` | `null` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for lambda function. | `number` | `null` | no |
| <a name="input_lambda_reserved_concurrency"></a> [lambda\_reserved\_concurrency](#input\_lambda\_reserved\_concurrency) | Optional reserved concurrency for subscriber Lambda.<br/>Caps concurrent executions for this function (all triggers); if set below sqs\_maximum\_concurrency, it is the effective ceiling for SQS-driven invokes. | `number` | `null` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime. | `string` | `null` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout in seconds for lambda function. | `number` | `null` | no |
| <a name="input_log_group_name_patterns"></a> [log\_group\_name\_patterns](#input\_log\_group\_name\_patterns) | List of log group name patterns. A log group is subscribed if its name<br/>matches any pattern. Patterns are joined with "\|" into a single Go<br/>regular expression and matched using regexp.MatchString() (partial match),<br/>so a plain string like "/aws/lambda" matches any log group whose name<br/>contains that substring. To subscribe to all log groups, use the special<br/>token "*" (not a glob wildcard). | `list(string)` | `null` | no |
| <a name="input_log_group_name_prefixes"></a> [log\_group\_name\_prefixes](#input\_log\_group\_name\_prefixes) | List of log group name prefixes. A log group is subscribed if its name<br/>starts with any of the provided strings. Internally each prefix is<br/>converted to the regex "^<prefix>.*" and matched using<br/>regexp.MatchString(). To subscribe to all log groups, use the special<br/>token "*" (not a glob wildcard). | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources. | `string` | n/a | yes |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | Maximum number of concurrent workers when processing log groups. | `number` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix to write log records to. | `string` | `""` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention in days for cloudwatch log group. | `number` | `365` | no |
| <a name="input_sam_release_version"></a> [sam\_release\_version](#input\_sam\_release\_version) | Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps. | `string` | `null` | no |
| <a name="input_sqs_batch_size"></a> [sqs\_batch\_size](#input\_sqs\_batch\_size) | SQS batch size for subscriber event source mapping. | `number` | `null` | no |
| <a name="input_sqs_maximum_concurrency"></a> [sqs\_maximum\_concurrency](#input\_sqs\_maximum\_concurrency) | Maximum concurrent Lambda invokes for subscriber SQS event source mapping.<br/>Effective parallelism is also limited by lambda\_reserved\_concurrency when that is set lower. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources. | `map(string)` | `{}` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | Logging verbosity for Lambda. Highest log verbosity is 9. | `number` | `null` | no |
| <a name="input_wait_for_discovery_on_apply"></a> [wait\_for\_discovery\_on\_apply](#input\_wait\_for\_discovery\_on\_apply) | If true, subscriber null\_resource.discovery\_on\_apply waits until the queue<br/>drains and fails on DLQ growth. If false, enqueue discovery only (no apply<br/>polling). Destroy-time cleanup behavior is separate.<br/>When true, requires the AWS CLI on the Terraform runner. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_role_arn"></a> [destination\_role\_arn](#output\_destination\_role\_arn) | Role for CloudWatch Logs to assume when writing to Firehose |
| <a name="output_firehose_arn"></a> [firehose\_arn](#output\_firehose\_arn) | Kinesis Firehose Delivery Stream ARN |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Kinesis Firehose Log Group |
| <a name="output_subscriber"></a> [subscriber](#output\_subscriber) | Subscriber module |
<!-- END_TF_DOCS -->
