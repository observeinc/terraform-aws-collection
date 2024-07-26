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


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_observe"></a> [observe](#requirement\_observe) | ~> 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_observe"></a> [observe](#provider\_observe) | ~> 0.14 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_stack"></a> [stack](#module\_stack) | ../..//modules/stack | n/a |

## Resources

| Name | Type |
|------|------|
| [observe_datastream.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/datastream) | resource |
| [observe_filedrop.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/filedrop) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [observe_workspace.default](https://registry.terraform.io/providers/observeinc/observe/latest/docs/data-sources/workspace) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
