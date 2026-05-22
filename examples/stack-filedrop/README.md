# Observe stack with Filedrop 

This module demonstrates how to configure the Observe stack module to point to
a filedrop destination.

To run this example you need to execute:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run terraform destroy when you don't need these resources.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_observe"></a> [observe](#requirement\_observe) | ~> 0.14 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_observe"></a> [observe](#provider\_observe) | ~> 0.14 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_stack"></a> [stack](#module\_stack) | ../..//modules/forwarder | n/a |

## Resources

| Name | Type |
|------|------|
| [observe_datastream.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/datastream) | resource |
| [observe_filedrop.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/filedrop) | resource |
| [random_string.run](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [observe_workspace.default](https://registry.terraform.io/providers/observeinc/observe/latest/docs/data-sources/workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_test_run_id"></a> [test\_run\_id](#input\_test\_run\_id) | Workflow run ID for CI (set via TF\_VAR\_test\_run\_id=github.run\_id). Omit locally for a random suffix. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | Forwarder Lambda log group |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | SQS Queue ARN for the forwarder |
<!-- END_TF_DOCS -->
