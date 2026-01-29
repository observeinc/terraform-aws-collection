# Observe AWS External Role

This module configures an IAM role that can be assumed by Observe.

## Usage

```hcl
resource "random_pet" "this" {}

data "observe_cloud_info" {}

data "observe_workspace" "default" {
    name = "Default"
}

resource "observe_datastream" "example" {
    workspace = data.observe_workspace.default.oid
    name      = random_pet.this.id
}

module "external_role" {
  source     = "observeinc/collection/aws//modules/externalrole"
  name       = random_pet.this.id

  observe_aws_account_id = data.observe_cloud_info.account_id
  datastream_ids         = [observe_datastream.example.id]
  allowed_actions        = [
    "cloudwatch:ListMetrics",
    "cloudwatch:GetMetricsData",
    "tags:GetResources",
  ]
}

```

<!-- BEGIN_TF_DOCS -->
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_actions"></a> [allowed\_actions](#input\_allowed\_actions) | Set of IAM actions external entity is allowed to perform. | `list(string)` | n/a | yes |
| <a name="input_datastream_ids"></a> [datastream\_ids](#input\_datastream\_ids) | Observe datastreams collected data is intended for. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for IAM role. | `string` | n/a | yes |
| <a name="input_observe_aws_account_id"></a> [observe\_aws\_account\_id](#input\_observe\_aws\_account\_id) | AWS account ID for Observe tenant | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN for IAM role to be assumed by Observe |
<!-- END_TF_DOCS -->
