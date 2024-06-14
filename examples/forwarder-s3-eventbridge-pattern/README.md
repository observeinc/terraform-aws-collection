# Forwarding a subset of S3 files via EventBridge

This module demonstrates how to forward a subset of objects from an S3 bucket
which send bucket notifications to EventBridge.

To run this example you need to execute:

```
$ terraform init
$ terraform plan
$ terraform apply
```

After applying, you can copy files to the source bucket, and verify if they are written to the destination:

```
aws s3 cp ./main.tf s3://`terraform output -raw source_bucket`/a/foo/main.tf
aws s3 cp ./main.tf s3://`terraform output -raw source_bucket`/a/bar/main.tf
aws s3 cp ./main.tf s3://`terraform output -raw source_bucket`/a/baz/main.tf
...
aws s3 ls `terraform output -raw destination_bucket`/a/
        PRE bar/
        PRE foo/
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_forwarder"></a> [forwarder](#module\_forwarder) | ../..//modules/forwarder | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_bucket"></a> [destination\_bucket](#output\_destination\_bucket) | Destination bucket name to read objects from. |
| <a name="output_source_bucket"></a> [source\_bucket](#output\_source\_bucket) | Source bucket name to write objects to. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
