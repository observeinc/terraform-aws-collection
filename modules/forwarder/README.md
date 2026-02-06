# Observe AWS Forwarder

## Usage

This is a minimal example for setting up a forwarder:

- create an `observe_datastream`
- create an `observe_filedrop`. You must provide an ARN for a role that does not yet exist.
- instantiate the forwarder module with the `observe_filedrop` and the `name` of the role you used in the previous step.

```hcl
data "observe_workspace" "default" {
  name = "Default"
}

resource "random_pet" "this" {}

data "observe_datastream" "this" {
  workspace = data.observe_workspace.default.oid
  name      = random_pet.this.id
}

resource "observe_filedrop" "this" {
  workspace  = data.observe_workspace.default.oid
  datastream = observe_datastream.this.oid

  config {
    provider {
      aws {
        region   = "us-west-2"
        role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${random_pet.this.id}"
      }
    }
  }
}

resource "aws_s3_bucket" "source" {
  bucket        = random_pet.this.id
  force_destroy = true
}

resource "aws_s3_bucket_notification" "source" {
  bucket      = aws_s3_bucket.source.id
  eventbridge = true
}

module "forwarder" {
  source              = "observeinc/collection/aws//modules/forwarder"

  name                = random_pet.this.id
  destination         = observe_filedrop.this.endpoint[0].s3[0]
  source_bucket_names = [aws_s3_bucket.source.bucket]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sam_asset"></a> [sam\_asset](#module\_sam\_asset) | ../sam_asset | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_redrive_allow_policy.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_allow_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_kms_key"></a> [cloudwatch\_log\_kms\_key](#input\_cloudwatch\_log\_kms\_key) | KMS key to use for cloudwatch log encryption. | `string` | `null` | no |
| <a name="input_code_uri"></a> [code\_uri](#input\_code\_uri) | S3 URI for lambda binary. If set, takes precedence over sam\_release\_version. | `string` | `""` | no |
| <a name="input_content_type_overrides"></a> [content\_type\_overrides](#input\_content\_type\_overrides) | A list of key value pairs. The key is a regular expression which is<br>applied to the S3 source (<bucket>/<key>) of forwarded files. The value<br>is the content type to set for matching files. For example,<br>`\.json$=application/x-ndjson` would forward all files ending in `.json`<br>as newline delimited JSON | <pre>list(object({<br>    pattern      = string<br>    content_type = string<br>  }))</pre> | `[]` | no |
| <a name="input_debug_endpoint"></a> [debug\_endpoint](#input\_debug\_endpoint) | Endpoint to send debugging telemetry to. Sets the OTEL\_EXPORTER\_OTLP\_ENDPOINT environment variable for the lambda function. | `string` | `""` | no |
| <a name="input_destination"></a> [destination](#input\_destination) | Destination filedrop | <pre>object({<br>    arn    = optional(string, "")<br>    bucket = optional(string, "")<br>    prefix = optional(string, "")<br>    # exclusively for backward compatible HTTP endpoint<br>    uri = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_lambda_env_vars"></a> [lambda\_env\_vars](#input\_lambda\_env\_vars) | Environment variables to be passed into lambda. | `map(string)` | `{}` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for lambda function. | `number` | `null` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime. | `string` | `"provided.al2023"` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout in seconds for lambda function. | `number` | `null` | no |
| <a name="input_max_file_size"></a> [max\_file\_size](#input\_max\_file\_size) | Max file size for objects to process (in bytes), default is 1GB | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of role. Since this name must be unique within the<br>account, it will be reused for most of the resources created by this<br>module. | `string` | n/a | yes |
| <a name="input_queue_batch_size"></a> [queue\_batch\_size](#input\_queue\_batch\_size) | Max number of items to process in single lambda execution | `number` | `10` | no |
| <a name="input_queue_delay_seconds"></a> [queue\_delay\_seconds](#input\_queue\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be<br>delayed. An integer from 0 to 900 (15 minutes). | `number` | `0` | no |
| <a name="input_queue_max_receive_count"></a> [queue\_max\_receive\_count](#input\_queue\_max\_receive\_count) | The number of times a message is delivered to the source queue before being<br>moved to the dead-letter queue. A dead letter queue will only be created if<br>this value is greater than 0. | `number` | `4` | no |
| <a name="input_queue_maximum_batching_window_in_seconds"></a> [queue\_maximum\_batching\_window\_in\_seconds](#input\_queue\_maximum\_batching\_window\_in\_seconds) | The maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300) | `number` | `1` | no |
| <a name="input_queue_message_retention_seconds"></a> [queue\_message\_retention\_seconds](#input\_queue\_message\_retention\_seconds) | Maximum amount of time a message will be retained in queue.<br>This value applies to both source queue and dead letter queue if one<br>exists. | `number` | `345600` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Retention in days of cloudwatch log group | `number` | `365` | no |
| <a name="input_sam_release_version"></a> [sam\_release\_version](#input\_sam\_release\_version) | Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps. | `string` | `""` | no |
| <a name="input_source_bucket_names"></a> [source\_bucket\_names](#input\_source\_bucket\_names) | A list of bucket names which the forwarder is allowed to read from.  This<br>list only affects permissions, and supports wildcards. In order to have<br>files copied to Filedrop, you must also subscribe S3 Bucket Notifications<br>to the forwarder. | `list(string)` | `[]` | no |
| <a name="input_source_kms_key_arns"></a> [source\_kms\_key\_arns](#input\_source\_kms\_key\_arns) | A list of KMS Key ARNs the forwarder is allowed to use to decrypt objects in S3. | `list(string)` | `[]` | no |
| <a name="input_source_object_keys"></a> [source\_object\_keys](#input\_source\_object\_keys) | A list of object key patterns the forwarder is allowed to read from for<br>provided source buckets. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_source_topic_arns"></a> [source\_topic\_arns](#input\_source\_topic\_arns) | A list of SNS topics the forwarder is allowed to be subscribed to. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources. | `map(string)` | `{}` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | Logging verbosity for Lambda. Highest log verbosity is 9. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Lambda log group. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | SQS Queue ARN. Events sent to this queue are delivered to the forwarder Lambda. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
