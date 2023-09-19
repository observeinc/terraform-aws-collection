# AWS Config

This module sets up AWS Config to store configuration data to a provided S3 bucket.

⚠️ _You can specify only one configuration recorder for each AWS Region for each account._

# Usage

```
module "observe_collection" {
  source = "observeinc/collection/aws//modules/config"
  bucket = "my-example-bucket"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
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
| [aws_config_configuration_recorder.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | The name of the S3 bucket used to store the configuration history. | `string` | n/a | yes |
| <a name="input_delivery_frequency"></a> [delivery\_frequency](#input\_delivery\_frequency) | The frequency with which AWS Config recurringly delivers configuration snapshots | `string` | `"Three_Hours"` | no |
| <a name="input_include_global_resource_types"></a> [include\_global\_resource\_types](#input\_include\_global\_resource\_types) | Specifies whether AWS Config includes all supported types of global<br>resources with the resources that it records. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to set on AWS Config resources. | `string` | `"default"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix for the specified S3 bucket. | `string` | `""` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | The ARN of the SNS topic that AWS Config delivers notifications to. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
