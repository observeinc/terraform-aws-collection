# AWS Config

This module sets up AWS Config to store configuration data to a provided S3 bucket.

⚠️ _You can specify only one configuration recorder for each AWS Region for each account._

# Usage

```json
module "config" {
  source = "observeinc/collection/aws//modules/config"
  bucket = "my-example-bucket"
}
```

By omission, all resource types are collected, including global resources such as IAM.

To disable collection for global resources, provide `include_global_resource_types`:

```json
module "config" {
  source                         = "observeinc/collection/aws//modules/config"
  bucket                         = "my-example-bucket"
  include_global_resource_types  = false
}
```

You can exclude specific resource types, provide `exclude_resource_types`:

```json
module "config" {
  source                  = "observeinc/collection/aws//modules/config"
  bucket                  = "my-example-bucket"
  exclude_resource_types  = ["AWS::EC2::Instance"]
}
```

To only collect certain resource types, provide `include_resource_types`:

```json
module "config" {
  source                  = "observeinc/collection/aws//modules/config"
  bucket                  = "my-example-bucket"
  include_resource_types  = ["AWS::EC2::Instance"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_config_configuration_recorder.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_account_alias.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) | data source |
| [aws_iam_policy.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | The name of the S3 bucket used to store the configuration history. | `string` | n/a | yes |
| <a name="input_delivery_frequency"></a> [delivery\_frequency](#input\_delivery\_frequency) | The frequency with which AWS Config recurringly delivers configuration<br>snapshots. Valid values: One\_Hour, Three\_Hours, Six\_Hours, Twelve\_Hours,<br>TwentyFour\_Hours<br>(https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigSnapshotDeliveryProperties.html)." | `string` | `"Three_Hours"` | no |
| <a name="input_exclude_resource_types"></a> [exclude\_resource\_types](#input\_exclude\_resource\_types) | Exclude a subset of resource types from configuration collection. This<br>parameter is mutually exclusive with IncludeResourceTypes. | `list(string)` | `[]` | no |
| <a name="input_include_global_resource_types"></a> [include\_global\_resource\_types](#input\_include\_global\_resource\_types) | Specifies whether AWS Config includes all supported types of global<br>resources with the resources that it records. This field only takes<br>effect if all resources are included for collection. include\_resource\_types<br>must be set to *, and exclude\_resource\_types must not be set. | `bool` | `true` | no |
| <a name="input_include_resource_types"></a> [include\_resource\_types](#input\_include\_resource\_types) | Restrict configuration collection to a subset of resource types. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name to set on AWS Config resources. | `string` | `"default"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix for the specified S3 bucket. | `string` | `""` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | The ARN of the SNS topic that AWS Config delivers notifications to. | `string` | `null` | no |
| <a name="input_tag_account_alias"></a> [tag\_account\_alias](#input\_tag\_account\_alias) | Set tag based on account alias. | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. See LICENSE for full details.
