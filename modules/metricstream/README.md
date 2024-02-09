# Observe AWS Metric Stream

This module ingests CloudWatch Metrics into Observe.

## Usage

```hcl
resource "random_pet" "this" {}

resource "aws_s3_bucket" "this" {
  bucket = random_pet.this.id
}

module "metric_stream" {
  source     = "observeinc/cloudformation/aws//modules/metricstream"
  name       = random_pet.this.id
  bucket_arn = aws_s3_bucket.this.arn
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.firehose_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.firehose_log_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_cloudwatch_metric_stream.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream) | resource |
| [aws_iam_role.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.metric_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kinesis_firehose_delivery_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_iam_policy_document.firehose_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_s3writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.metric_stream_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.metric_stream_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | S3 Bucket ARN to write log records to. | `string` | n/a | yes |
| <a name="input_buffering_interval"></a> [buffering\_interval](#input\_buffering\_interval) | Buffer incoming data for the specified period of time, in seconds, before<br>delivering it to S3. | `number` | `60` | no |
| <a name="input_buffering_size"></a> [buffering\_size](#input\_buffering\_size) | Buffer incoming data to the specified size, in MiBs, before delivering it<br>to S3. | `number` | `1` | no |
| <a name="input_exclude_filters"></a> [exclude\_filters](#input\_exclude\_filters) | List of exclusion filters. Mutually exclusive with inclusion filters | <pre>list(object({<br>    namespace    = string<br>    metric_names = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_include_filters"></a> [include\_filters](#input\_include\_filters) | List of inclusion filters. | <pre>list(object({<br>    namespace    = string<br>    metric_names = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for resources. | `string` | n/a | yes |
| <a name="input_output_format"></a> [output\_format](#input\_output\_format) | The output format for CloudWatch Metrics. | `string` | `"json"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix to write log records to. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
