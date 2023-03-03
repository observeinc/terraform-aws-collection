# Observe AWS Collection

This module assembles different methods of collecting data from AWS into
Observe. It is intended as both a starting point and as a reference.

The module sets up the following forwarding methods:

- the Observe lambda
- an S3 bucket, subscribed to the aforementioned Lambda
- a Firehose stream

Given these egresses, we extract data from the following sources:

- Cloudwatch Metrics, via Firehose
- CloudTrail, via S3
- EventBridge, via Firehose
- AWS snapshot data, via Lambda

# Usage

The following snippet installs the Observe AWS collection stack to a single region:

```
module "observe_collection" {
  source           = "github.com/observeinc/terraform-aws-collection"
  observe_customer = ""
  observe_token    = ""
}
```

## Common Options

The snippet below installs the Observe AWS collection stack so that all supported
CloudWatch Logs, CloudWatch metrics, CloudTrail records, and AWS resource updates
are collected, except for some excluded items:

```
module "observe_collection" {
  source           = "github.com/observeinc/terraform-aws-collection"
  observe_customer = ""
  observe_token    = ""
  
  subscribed_log_group_matches = [".*"]
  subscribed_log_group_excludes = ["/aws/elasticbeanstalk/my-app.*"]
  snapshot_exclude = ["kms:Describe*"]
  cloudwatch_metrics_exclude_filters = ["AWS/KMS"]
}
```

# Diagram

     ┌──────────────────┐                          ┌───────────────┐    ┌─────────────┐
     │cloudwatch metrics├──┐                       │   s3 bucket   │    │  cloudtrail │
     └──────────────────┘  │           ┌───────────►               ◄────┤             │
                           │           │           └────────┬──────┘    └─────────────┘
                           │           │                    │
                           │           │                    │
                           │     ┌─────┴──────┐             │
                           └─────►            │             │
                                 │  Firehose  ├──────┐      │
             ┌───────────────────►            │      │      │
             │                   └───▲──┬─────┘      │      │
             │                       │  │            │      │
             │                       │  │        ┌───▼───┐  │
       ┌─────┴─────┐                 │  │        │       │  │
       │eventbridge│                 │  │        │observe│  │
       └─────┬─────┘                 │  │        │       │  │
             │            ┌──────────┴──▼─┐      └────▲──┘  │
             │            │cloudwatch logs│           │     │
             │            └──────────┬──┬─┘           │     │
             │                       │  │             │     │
             │                       │  │             │     │
             │                   ┌───┴──▼─────┐       │     │
             └───────────────────►            ├───────┘     │
                                 │   Lambda   │             │
             ┌───────────────────►            ◄─────────────┘
             │                   └────────────┘
    ┌────────┴─────────┐
    │ cloudwatch logs  │
    └──────────────────┘

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.75 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.75 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_observe_cloudwatch_logs_subscription"></a> [observe\_cloudwatch\_logs\_subscription](#module\_observe\_cloudwatch\_logs\_subscription) | observeinc/cloudwatch-logs-subscription/aws | 0.5.0 |
| <a name="module_observe_cloudwatch_metrics"></a> [observe\_cloudwatch\_metrics](#module\_observe\_cloudwatch\_metrics) | observeinc/kinesis-firehose/aws//modules/cloudwatch_metrics | 2.0.0 |
| <a name="module_observe_firehose_eventbridge"></a> [observe\_firehose\_eventbridge](#module\_observe\_firehose\_eventbridge) | observeinc/kinesis-firehose/aws//modules/eventbridge | 2.0.0 |
| <a name="module_observe_kinesis_firehose"></a> [observe\_kinesis\_firehose](#module\_observe\_kinesis\_firehose) | observeinc/kinesis-firehose/aws | 2.0.0 |
| <a name="module_observe_lambda"></a> [observe\_lambda](#module\_observe\_lambda) | observeinc/lambda/aws | 1.1.2 |
| <a name="module_observe_lambda_s3_bucket_subscription"></a> [observe\_lambda\_s3\_bucket\_subscription](#module\_observe\_lambda\_s3\_bucket\_subscription) | observeinc/lambda/aws//modules/s3_bucket_subscription | 1.1.2 |
| <a name="module_observe_lambda_snapshot"></a> [observe\_lambda\_snapshot](#module\_observe\_lambda\_snapshot) | observeinc/lambda/aws//modules/snapshot | 1.1.2 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_event_rule.rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_log_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_redshift_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/redshift_service_account) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudtrail_enable"></a> [cloudtrail\_enable](#input\_cloudtrail\_enable) | Whether to create a CloudTrail trail.<br><br>Useful for avoiding the 'trails per region' quota of 5, such as when testing. | `bool` | `true` | no |
| <a name="input_cloudtrail_enable_log_file_validation"></a> [cloudtrail\_enable\_log\_file\_validation](#input\_cloudtrail\_enable\_log\_file\_validation) | Whether log file integrity validation is enabled for CloudTrail. Defalults to false. | `bool` | `false` | no |
| <a name="input_cloudtrail_exclude_management_event_sources"></a> [cloudtrail\_exclude\_management\_event\_sources](#input\_cloudtrail\_exclude\_management\_event\_sources) | A list of management event sources to exclude.<br><br>See the following link for more info:<br>https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html | `set(string)` | <pre>[<br>  "kms.amazonaws.com",<br>  "rdsdata.amazonaws.com"<br>]</pre> | no |
| <a name="input_cloudtrail_is_multi_region_trail"></a> [cloudtrail\_is\_multi\_region\_trail](#input\_cloudtrail\_is\_multi\_region\_trail) | Whether to enable multi region trail export | `bool` | `true` | no |
| <a name="input_cloudwatch_metrics_exclude_filters"></a> [cloudwatch\_metrics\_exclude\_filters](#input\_cloudwatch\_metrics\_exclude\_filters) | Namespaces to exclude. Mutually exclusive with cloudwatch\_metrics\_include\_filters.<br><br>To disable Cloudwatch Metrics Stream entirely, use ["*"]. | `set(string)` | `[]` | no |
| <a name="input_cloudwatch_metrics_include_filters"></a> [cloudwatch\_metrics\_include\_filters](#input\_cloudwatch\_metrics\_include\_filters) | Namespaces to include. Mutually exclusive with cloudwatch\_metrics\_exclude\_filters. | `set(string)` | `[]` | no |
| <a name="input_dead_letter_queue_destination"></a> [dead\_letter\_queue\_destination](#input\_dead\_letter\_queue\_destination) | Send failed events/function executions to a dead letter queue arn sns or sqs | `string` | `null` | no |
| <a name="input_eventbridge_rules"></a> [eventbridge\_rules](#input\_eventbridge\_rules) | Eventbridge events matching these rules will be forwarded to Observe. Map<br>keys are only used to provide stable resource addresses.<br><br>If null, a default set of rules will be used. | <pre>map(object({<br>    description   = string<br>    event_pattern = string<br>  }))</pre> | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ARN to use to encrypt the logs delivered by CloudTrail. | `string` | `""` | no |
| <a name="input_lambda_envvars"></a> [lambda\_envvars](#input\_lambda\_envvars) | Environment variables | `map(any)` | `{}` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | The amount of memory that your function has access to. Increasing the function's memory also increases its CPU allocation.<br>The default value is 128 MB. The value must be a multiple of 64 MB. | `number` | `128` | no |
| <a name="input_lambda_reserved_concurrent_executions"></a> [lambda\_reserved\_concurrent\_executions](#input\_lambda\_reserved\_concurrent\_executions) | The number of simultaneous executions to reserve for the function. | `number` | `100` | no |
| <a name="input_lambda_s3_custom_rules"></a> [lambda\_s3\_custom\_rules](#input\_lambda\_s3\_custom\_rules) | List of rules to evaluate how to upload a given S3 object to Observe. | <pre>list(object({<br>    pattern = string<br>    headers = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | The amount of time that Lambda allows a function to run before stopping it.<br>The maximum allowed value is 900 seconds. | `number` | `60` | no |
| <a name="input_lambda_version"></a> [lambda\_version](#input\_lambda\_version) | Lambda version | `string` | `"latest"` | no |
| <a name="input_log_subscription_name"></a> [log\_subscription\_name](#input\_log\_subscription\_name) | Name for log subscription resources to be created | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources to be created | `string` | `"observe-collection"` | no |
| <a name="input_observe_customer"></a> [observe\_customer](#input\_observe\_customer) | Observe Customer ID | `string` | n/a | yes |
| <a name="input_observe_domain"></a> [observe\_domain](#input\_observe\_domain) | Observe Domain | `string` | `"observeinc.com"` | no |
| <a name="input_observe_token"></a> [observe\_token](#input\_observe\_token) | Observe Token | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention in days of cloudwatch log group | `number` | `365` | no |
| <a name="input_s3_exported_prefix"></a> [s3\_exported\_prefix](#input\_s3\_exported\_prefix) | Key prefix which is subscribed to be sent to Observe Lambda | `string` | `""` | no |
| <a name="input_s3_lifecycle_rule"></a> [s3\_lifecycle\_rule](#input\_s3\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | `[]` | no |
| <a name="input_s3_logging"></a> [s3\_logging](#input\_s3\_logging) | Enable S3 access log collection | `bool` | `false` | no |
| <a name="input_snapshot_exclude"></a> [snapshot\_exclude](#input\_snapshot\_exclude) | List of actions to exclude from being executed on snapshot request. | `list(string)` | `[]` | no |
| <a name="input_snapshot_include"></a> [snapshot\_include](#input\_snapshot\_include) | List of actions to include in snapshot request. | `list(string)` | `[]` | no |
| <a name="input_snapshot_schedule_expression"></a> [snapshot\_schedule\_expression](#input\_snapshot\_schedule\_expression) | Rate at which snapshot is triggered. Must be valid EventBridge expression | `string` | `"rate(3 hours)"` | no |
| <a name="input_subscribed_log_group_excludes"></a> [subscribed\_log\_group\_excludes](#input\_subscribed\_log\_group\_excludes) | A list of regex patterns describing CloudWatch log groups to NOT subscribe to.<br><br>See https://github.com/observeinc/terraform-aws-cloudwatch-logs-subscription#input_log_group_excludes for more info" | `list(string)` | `[]` | no |
| <a name="input_subscribed_log_group_filter_pattern"></a> [subscribed\_log\_group\_filter\_pattern](#input\_subscribed\_log\_group\_filter\_pattern) | A filter pattern for a CloudWatch Logs subscription filter.<br><br>See https://github.com/observeinc/terraform-aws-cloudwatch-logs-subscription#input_filter_pattern or<br>https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html for more info" | `string` | `""` | no |
| <a name="input_subscribed_log_group_matches"></a> [subscribed\_log\_group\_matches](#input\_subscribed\_log\_group\_matches) | A list of regex patterns describing CloudWatch log groups to subscribe to.<br><br>See https://github.com/observeinc/terraform-aws-cloudwatch-logs-subscription#input_log_group_matches for more info" | `list(string)` | `[]` | no |
| <a name="input_subscribed_s3_bucket_arns"></a> [subscribed\_s3\_bucket\_arns](#input\_subscribed\_s3\_bucket\_arns) | List of additional S3 bucket ARNs to subscribe lambda to. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | S3 bucket subscribed to Observe Lambda |
| <a name="output_observe_kinesis_firehose"></a> [observe\_kinesis\_firehose](#output\_observe\_kinesis\_firehose) | Observe Kinesis Firehose module |
| <a name="output_observe_lambda"></a> [observe\_lambda](#output\_observe\_lambda) | Observe Lambda module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
