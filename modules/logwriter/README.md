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

This module embeds an optional [subscriber]("../subscriber/README.md") module
to dynamically subscribe log groups to the provisioned Kinesis Firehose. You
can activate this mode by providing a set of `log_group_name_patterns` or
`log_group_name_prefixes`:

```hcl
module "logwriter" {
  name                    = random_pet.this.id
  bucket_arn              = aws_s3_bucket.this.arn
  log_group_name_patterns = ["*"]
  discovery_rate          = "24 hours"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
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
| <a name="input_buffering_interval"></a> [buffering\_interval](#input\_buffering\_interval) | Buffer incoming data for the specified period of time, in seconds, before<br>delivering it to S3. | `number` | `60` | no |
| <a name="input_buffering_size"></a> [buffering\_size](#input\_buffering\_size) | Buffer incoming data to the specified size, in MiBs, before delivering it<br>to S3. | `number` | `1` | no |
| <a name="input_cloudwatch_log_kms_key"></a> [cloudwatch\_log\_kms\_key](#input\_cloudwatch\_log\_kms\_key) | KMS key to use for cloudwatch log encryption. | `string` | `null` | no |
| <a name="input_code_uri"></a> [code\_uri](#input\_code\_uri) | S3 URI for lambda binary. If set, takes precedence over sam\_release\_version. | `string` | `null` | no |
| <a name="input_debug_endpoint"></a> [debug\_endpoint](#input\_debug\_endpoint) | Endpoint to send debugging telemetry to. Sets the OTEL\_EXPORTER\_OTLP\_ENDPOINT environment variable for the lambda function. | `string` | `null` | no |
| <a name="input_discovery_rate"></a> [discovery\_rate](#input\_discovery\_rate) | EventBridge rate expression for periodically triggering discovery. If not<br>set, no eventbridge rules are configured. | `string` | `null` | no |
| <a name="input_exclude_log_group_name_patterns"></a> [exclude\_log\_group\_name\_patterns](#input\_exclude\_log\_group\_name\_patterns) | Exclude any log group names matching the provided set of regular<br>expressions. | `list(string)` | `null` | no |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Subscription filter name. Existing filters that have this name as a prefix<br>will be removed. | `string` | `null` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | Subscription filter pattern. | `string` | `null` | no |
| <a name="input_lambda_env_vars"></a> [lambda\_env\_vars](#input\_lambda\_env\_vars) | Environment variables to be passed into lambda. | `map(string)` | `null` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for lambda function. | `number` | `null` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime. | `string` | `null` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout in seconds for lambda function. | `number` | `null` | no |
| <a name="input_log_group_name_patterns"></a> [log\_group\_name\_patterns](#input\_log\_group\_name\_patterns) | Subscribe to CloudWatch log groups matching any of the provided patterns<br>based on a case-sensitive substring search. To subscribe to all log groups<br>use the wildcard operator *. | `list(string)` | `null` | no |
| <a name="input_log_group_name_prefixes"></a> [log\_group\_name\_prefixes](#input\_log\_group\_name\_prefixes) | Subscribe to CloudWatch log groups matching any of the provided prefixes.<br>To subscribe to all log groups use the wildcard operator *. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources. | `string` | n/a | yes |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | Maximum number of concurrent workers when processing log groups. | `number` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix to write log records to. | `string` | `""` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention in days for cloudwatch log group. | `number` | `365` | no |
| <a name="input_sam_release_version"></a> [sam\_release\_version](#input\_sam\_release\_version) | Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources. | `map(string)` | `{}` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | Logging verbosity for Lambda. Highest log verbosity is 9. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_role_arn"></a> [destination\_role\_arn](#output\_destination\_role\_arn) | Role for CloudWatch Logs to assume when writing to Firehose |
| <a name="output_firehose_arn"></a> [firehose\_arn](#output\_firehose\_arn) | Kinesis Firehose Delivery Stream ARN |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Kinesis Firehose Log Group |
| <a name="output_subscriber"></a> [subscriber](#output\_subscriber) | Subscriber module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
