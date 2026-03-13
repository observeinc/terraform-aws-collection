# Observe stack with HTTP  backend

This module demonstrates how to configure the Observe stack module to point to
an HTTPS destination.

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
| <a name="requirement_observe"></a> [observe](#requirement\_observe) | >= 0.14.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_observe"></a> [observe](#provider\_observe) | >= 0.14.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_stack"></a> [stack](#module\_stack) | ../..//modules/stack | n/a |

## Resources

| Name | Type |
|------|------|
| [observe_datastream.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/datastream) | resource |
| [observe_datastream_token.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/datastream_token) | resource |
| [observe_ingest_info.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/data-sources/ingest_info) | data source |
| [observe_workspace.default](https://registry.terraform.io/providers/observeinc/observe/latest/docs/data-sources/workspace) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
