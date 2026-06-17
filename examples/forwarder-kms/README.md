# Forwarding KMS encrypted buckets

This module demonstrates how to forward objects from a KMS encrypted bucket. The
`forwarder` module must be configured with a list of `source_kms_key_arns`, and
the KMS key must have a policy that grants the lambda function permission to
decrypt objects.

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |
| <a name="requirement_observe"></a> [observe](#requirement\_observe) | ~> 0.14 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |
| <a name="provider_observe"></a> [observe](#provider\_observe) | ~> 0.14 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_forwarder"></a> [forwarder](#module\_forwarder) | ../..//modules/forwarder | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [observe_datastream.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/datastream) | resource |
| [observe_filedrop.this](https://registry.terraform.io/providers/observeinc/observe/latest/docs/resources/filedrop) | resource |
| [random_string.run](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_default_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [observe_workspace.default](https://registry.terraform.io/providers/observeinc/observe/latest/docs/data-sources/workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_test_run_id"></a> [test\_run\_id](#input\_test\_run\_id) | Workflow run ID for CI (set via TF\_VAR\_test\_run\_id=github.run\_id). Omit locally for a random suffix. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datastream"></a> [datastream](#output\_datastream) | Observe Datastream containing data copied from source bucket. |
| <a name="output_source_bucket"></a> [source\_bucket](#output\_source\_bucket) | Source bucket name to write objects to. This bucket is encrypted using KMS. |
<!-- END_TF_DOCS -->
