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
| <a name="module_sam_asset"></a> [sam\_asset](#module\_sam\_asset) | ../sam_asset | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
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
| <a name="input_cloudwatch_log_kms_key"></a> [cloudwatch\_log\_kms\_key](#input\_cloudwatch\_log\_kms\_key) | KMS key to use for cloudwatch log encryption. | `string` | `null` | no |
| <a name="input_code_uri"></a> [code\_uri](#input\_code\_uri) | S3 URI for lambda binary. If set, takes precedence over sam\_release\_version. | `string` | `""` | no |
| <a name="input_dead_letter_queue_tags"></a> [dead\_letter\_queue\_tags](#input\_dead\_letter\_queue\_tags) | Tags to add to the deadletter queue. Merged with tags variable, with these taking precedence for any overlapping keys. | `map(string)` | `{}` | no |
| <a name="input_debug_endpoint"></a> [debug\_endpoint](#input\_debug\_endpoint) | Endpoint to send debugging telemetry to. Sets the OTEL\_EXPORTER\_OTLP\_ENDPOINT environment variable for the lambda function. | `string` | `""` | no |
| <a name="input_destination_iam_arn"></a> [destination\_iam\_arn](#input\_destination\_iam\_arn) | ARN for destination iam policy | `string` | n/a | yes |
| <a name="input_discovery_rate"></a> [discovery\_rate](#input\_discovery\_rate) | EventBridge scheduler rate expression for periodically triggering discovery. If not set, no scheduler is configured. | `string` | `""` | no |
| <a name="input_exclude_log_group_name_patterns"></a> [exclude\_log\_group\_name\_patterns](#input\_exclude\_log\_group\_name\_patterns) | List of Go regular expression patterns. Any log group whose name matches<br/>a pattern is excluded from subscription, even if it matches an include<br/>pattern. Patterns are joined with "\|" into a single regex and matched<br/>using regexp.MatchString() (partial match), so the pattern only needs to<br/>appear somewhere in the log group name.<br/><br/>Exclusions take precedence over log\_group\_name\_patterns and<br/>log\_group\_name\_prefixes.<br/><br/>Examples:<br/>  ["/aws/lambda/noisy-fn"]   - exclude log groups containing "/aws/lambda/noisy-fn"<br/>  ["^/aws/elasticbeanstalk"] - exclude log groups starting with "/aws/elasticbeanstalk"<br/>  ["/aws/lambda", "/aws/ecs"] - exclude log groups containing either substring | `list(string)` | `[]` | no |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Subscription filter name. Existing filters that have this name as a prefix will be removed. | `string` | `"observe-logs-subscription"` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | Subscription filter pattern. | `string` | `""` | no |
| <a name="input_firehose_arn"></a> [firehose\_arn](#input\_firehose\_arn) | ARN for kinesis firehose | `string` | n/a | yes |
| <a name="input_lambda_env_vars"></a> [lambda\_env\_vars](#input\_lambda\_env\_vars) | Environment variables to be passed into lambda. | `map(string)` | `{}` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for lambda function. | `number` | `128` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime. | `string` | `"provided.al2023"` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout in seconds for lambda function. | `number` | `120` | no |
| <a name="input_log_group_name_patterns"></a> [log\_group\_name\_patterns](#input\_log\_group\_name\_patterns) | List of log group name patterns. A log group is subscribed if its name<br/>matches any pattern. Patterns matched using regexp.MatchString() (partial match),<br/>so a plain string like "/aws/lambda" matches any log group whose name<br/>contains that substring.<br/><br/>To subscribe to all log groups, use the special token "*". The "*"<br/>character selects all log groups.<br/><br/>Matching is regex-based, characters like "." are treated<br/>as regex metacharacters (matching any character), not literals.<br/><br/>Examples:<br/>  ["*"]                - subscribe to all log groups<br/>  ["/aws/lambda"]      - subscribe to any log group containing "/aws/lambda" | `list(string)` | `[]` | no |
| <a name="input_log_group_name_prefixes"></a> [log\_group\_name\_prefixes](#input\_log\_group\_name\_prefixes) | List of log group name prefixes. A log group is subscribed if its name<br/>starts with any of the provided strings. Internally each prefix is<br/>converted to the regex "^<prefix>.*" and matched using<br/>regexp.MatchString().<br/><br/>To subscribe to all log groups, use the special token "*". The "*"<br/>character selects all log groups; it is not a glob wildcard.<br/><br/>Examples:<br/>  ["*"]           - subscribe to all log groups<br/>  ["/aws/lambda"] - subscribe to log groups whose names start with "/aws/lambda" | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources. | `string` | n/a | yes |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | Maximum number of concurrent workers when processing log groups. | `number` | `1` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention in days for cloudwatch log group. | `number` | `365` | no |
| <a name="input_sam_release_version"></a> [sam\_release\_version](#input\_sam\_release\_version) | Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources. | `map(string)` | `{}` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | Logging verbosity for Lambda. Highest log verbosity is 9. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | Lambda Function ARN |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Lambda log group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sam_asset"></a> [sam\_asset](#module\_sam\_asset) | ../sam_asset | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
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
| <a name="input_cloudwatch_log_kms_key"></a> [cloudwatch\_log\_kms\_key](#input\_cloudwatch\_log\_kms\_key) | KMS key to use for cloudwatch log encryption. | `string` | `null` | no |
| <a name="input_code_uri"></a> [code\_uri](#input\_code\_uri) | S3 URI for lambda binary. If set, takes precedence over sam\_release\_version. | `string` | `""` | no |
| <a name="input_debug_endpoint"></a> [debug\_endpoint](#input\_debug\_endpoint) | Endpoint to send debugging telemetry to. Sets the OTEL\_EXPORTER\_OTLP\_ENDPOINT environment variable for the lambda function. | `string` | `""` | no |
| <a name="input_destination_iam_arn"></a> [destination\_iam\_arn](#input\_destination\_iam\_arn) | ARN for destination iam policy | `string` | n/a | yes |
| <a name="input_discovery_rate"></a> [discovery\_rate](#input\_discovery\_rate) | EventBridge scheduler rate expression for periodically triggering discovery. If not set, no scheduler is configured. | `string` | `""` | no |
| <a name="input_exclude_log_group_name_patterns"></a> [exclude\_log\_group\_name\_patterns](#input\_exclude\_log\_group\_name\_patterns) | List of Go regular expression patterns. Any log group whose name matches<br/>a pattern is excluded from subscription, even if it matches an include<br/>pattern. Patterns are joined with "\|" into a single regex and matched<br/>using regexp.MatchString() (partial match), so the pattern only needs to<br/>appear somewhere in the log group name.<br/><br/>Exclusions take precedence over log\_group\_name\_patterns and<br/>log\_group\_name\_prefixes.<br/><br/>Examples:<br/>  ["/aws/lambda/noisy-fn"]   - exclude log groups containing "/aws/lambda/noisy-fn"<br/>  ["^/aws/elasticbeanstalk"] - exclude log groups starting with "/aws/elasticbeanstalk"<br/>  ["/aws/lambda", "/aws/ecs"] - exclude log groups containing either substring | `list(string)` | `[]` | no |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Subscription filter name. Existing filters that have this name as a prefix will be removed. | `string` | `"observe-logs-subscription"` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | Subscription filter pattern. | `string` | `""` | no |
| <a name="input_firehose_arn"></a> [firehose\_arn](#input\_firehose\_arn) | ARN for kinesis firehose | `string` | n/a | yes |
| <a name="input_lambda_env_vars"></a> [lambda\_env\_vars](#input\_lambda\_env\_vars) | Environment variables to be passed into lambda. | `map(string)` | `{}` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for lambda function. | `number` | `128` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime. | `string` | `"provided.al2023"` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout in seconds for lambda function. | `number` | `120` | no |
| <a name="input_log_group_name_patterns"></a> [log\_group\_name\_patterns](#input\_log\_group\_name\_patterns) | List of log group name patterns. A log group is subscribed if its name<br/>matches any pattern. Patterns matched using regexp.MatchString() (partial match),<br/>so a plain string like "/aws/lambda" matches any log group whose name<br/>contains that substring.<br/><br/>To subscribe to all log groups, use the special token "*". The "*"<br/>character selects all log groups.<br/><br/>Matching is regex-based, characters like "." are treated<br/>as regex metacharacters (matching any character), not literals.<br/><br/>Examples:<br/>  ["*"]                - subscribe to all log groups<br/>  ["/aws/lambda"]      - subscribe to any log group containing "/aws/lambda" | `list(string)` | `[]` | no |
| <a name="input_log_group_name_prefixes"></a> [log\_group\_name\_prefixes](#input\_log\_group\_name\_prefixes) | List of log group name prefixes. A log group is subscribed if its name<br/>starts with any of the provided strings. Internally each prefix is<br/>converted to the regex "^<prefix>.*" and matched using<br/>regexp.MatchString().<br/><br/>To subscribe to all log groups, use the special token "*". The "*"<br/>character selects all log groups; it is not a glob wildcard.<br/><br/>Examples:<br/>  ["*"]           - subscribe to all log groups<br/>  ["/aws/lambda"] - subscribe to log groups whose names start with "/aws/lambda" | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources. | `string` | n/a | yes |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | Maximum number of concurrent workers when processing log groups. | `number` | `1` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention in days for cloudwatch log group. | `number` | `365` | no |
| <a name="input_sam_release_version"></a> [sam\_release\_version](#input\_sam\_release\_version) | Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources. | `map(string)` | `{}` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | Logging verbosity for Lambda. Highest log verbosity is 9. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | Lambda Function ARN |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Lambda log group |
<!-- END_TF_DOCS -->