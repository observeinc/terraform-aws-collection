# Observe AWS Subscriber

This app is specifically to register new cloudwatch log groups for the `logwriter` app. It will scan over existing log groups on an interval and compare them to provided prefixes and patterns. If they match it will then register new subscriptions from the log group to a provided kinesis firehose data stream. 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_samversion"></a> [samversion](#module\_samversion) | ../samversion | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.subscriber](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_event_source_mapping.subscriber_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.subscriber](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_scheduler_schedule.discovery_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_sqs_queue.dead_letter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.logging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.pass_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scheduler_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scheduler_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.subscription_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_code_uri"></a> [code\_uri](#input\_code\_uri) | S3 URI for lambda binary. If set, takes precedence over code\_version. | `string` | `""` | no |
| <a name="input_code_version"></a> [code\_version](#input\_code\_version) | Binary version as released on github.com/observeinc/aws-sam-apps. | `string` | `"1.19.3"` | no |
| <a name="input_debug_endpoint"></a> [debug\_endpoint](#input\_debug\_endpoint) | Endpoint to send debugging telemetry to. Sets the OTEL\_EXPORTER\_OTLP\_ENDPOINT environment variable for the lambda function. | `string` | `""` | no |
| <a name="input_destination_iam_arn"></a> [destination\_iam\_arn](#input\_destination\_iam\_arn) | ARN for destination iam policy | `string` | n/a | yes |
| <a name="input_discovery_rate"></a> [discovery\_rate](#input\_discovery\_rate) | EventBridge scheduler rate expression for periodically triggering discovery. If not set, no scheduler is configured. | `string` | `""` | no |
| <a name="input_exclude_log_group_name_patterns"></a> [exclude\_log\_group\_name\_patterns](#input\_exclude\_log\_group\_name\_patterns) | List of patterns as strings. This variable is usd to filter out log groups from subscription, and supports the use of regular expressions | `list(string)` | `[]` | no |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Subscription filter name. Existing filters that have this name as a prefix will be removed. | `string` | `"observe-logs-subscription"` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | Subscription filter pattern. | `string` | `""` | no |
| <a name="input_firehose_arn"></a> [firehose\_arn](#input\_firehose\_arn) | ARN for kinesis firehose | `string` | n/a | yes |
| <a name="input_lambda_env_vars"></a> [lambda\_env\_vars](#input\_lambda\_env\_vars) | Environment variables to be passed into lambda. | `map(string)` | `{}` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for lambda function. | `number` | `128` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout in seconds for lambda function. | `number` | `20` | no |
| <a name="input_log_group_name_patterns"></a> [log\_group\_name\_patterns](#input\_log\_group\_name\_patterns) | List of patterns as strings. We will only subscribe to log groups that have names matching one of the provided strings based on strings based on a case-sensitive substring search. To subscribe to all log groups, use the wildcard operator *. | `list(string)` | `[]` | no |
| <a name="input_log_group_name_prefixes"></a> [log\_group\_name\_prefixes](#input\_log\_group\_name\_prefixes) | List of prefixes as strings. The lambda function will only apply to log groups that start with a provided string. To subscribe to all log groups, use the wildcard operator *. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources. | `string` | n/a | yes |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | Maximum number of concurrent workers when processing log groups. | `number` | `1` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | Logging verbosity for Lambda. Highest log verbosity is 9. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | Lambda Function ARN |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Lambda log group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
