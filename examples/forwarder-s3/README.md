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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

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
| [random_string.run](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.s3_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_test_run_id"></a> [test\_run\_id](#input\_test\_run\_id) | Workflow run ID for CI (set via TF\_VAR\_test\_run\_id=github.run\_id). Omit locally for a random suffix. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination"></a> [destination](#output\_destination) | Destination bucket objects are copied to. |
| <a name="output_direct_source"></a> [direct\_source](#output\_direct\_source) | Source bucket subscribed directly |
| <a name="output_eventbridge_source"></a> [eventbridge\_source](#output\_eventbridge\_source) | Source bucket subscribed via eventbridge |
| <a name="output_sns_source"></a> [sns\_source](#output\_sns\_source) | Source bucket subscribed via SNS |
<!-- END_TF_DOCS -->
