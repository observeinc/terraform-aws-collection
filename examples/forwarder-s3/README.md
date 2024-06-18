# Subscribing objects via EventBridge

This module demonstrates how to forward objects from a source bucket using
EventBridge to trigger the Forwarder module.

To run this example you need to execute:

```
$ terraform init
$ terraform plan
$ terraform apply
```

The module will output three source buckets, one for each subscription type.
It will also output a destination bucket, where objects will be copied to by the forwarder.

```
→ aws s3 cp ./main.tf s3://`terraform output -raw direct_source`
upload: ./main.tf to s3://forwarder-s3-bucket-notification-src-20240617155010087500000002/main.tf
→ aws s3 ls s3://`terraform output -raw destination`
2024-06-17 08:52:55        869 main.tf
```

Note that this example may create resources which can cost money. Run terraform destroy when you don't need these resources.


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
| <a name="module_forwarder"></a> [forwarder](#module\_forwarder) | ../..//modules/forwarder | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.direct](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.direct](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_notification.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_notification.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.s3_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_iam_policy_document.s3_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination"></a> [destination](#output\_destination) | Destination bucket objects are copied to. |
| <a name="output_direct_source"></a> [direct\_source](#output\_direct\_source) | Source bucket subscribed directly |
| <a name="output_eventbridge_source"></a> [eventbridge\_source](#output\_eventbridge\_source) | Source bucket subscribed via eventbridge |
| <a name="output_sns_source"></a> [sns\_source](#output\_sns\_source) | Source bucket subscribed via SNS |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
