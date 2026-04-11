# Observe AWS Config Subscription

This module subscribes to an **existing** [AWS Config](https://aws.amazon.com/config/) installation via EventBridge rules. It forwards Config delivery and change events to a target (typically an SQS queue or Lambda function connected to Observe).

Unlike the [`config`](../config/README.md) module which creates a new AWS Config recorder and delivery channel, this module assumes Config is already enabled and only sets up the event routing.

The module creates three EventBridge rules:

- **Delivery** -- triggers when Config configuration history or snapshot deliveries complete, copying the delivered files from S3.
- **Change** -- triggers on Config Configuration Item changes, forwarding the change notification directly.
- **Oversized** -- triggers on oversized configuration item change notifications, copying the referenced S3 object.

## Usage

```hcl
module "configsubscription" {
  source = "observeinc/collection/aws//modules/configsubscription"

  target_arn = module.forwarder.queue_arn
}
```

When used through the [`stack`](../stack/README.md) module, provide the `delivery_bucket_name` of your existing Config delivery bucket:

```hcl
module "stack" {
  source = "observeinc/collection/aws//modules/stack"

  name        = "observe-collection"
  destination = observe_filedrop.this.endpoint[0].s3[0]

  configsubscription = {
    delivery_bucket_name = "my-existing-config-bucket"
  }
}
```

## Prerequisites

- AWS Config must already be enabled in the target account and region with a configuration recorder and delivery channel.
- The `target_arn` must accept EventBridge events (e.g., an SQS queue or Lambda function).

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
| [aws_cloudwatch_event_rule.change](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.oversized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.change](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.oversized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_account_alias.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources. | `string` | `"observe-config-subscription-"` | no |
| <a name="input_tag_account_alias"></a> [tag\_account\_alias](#input\_tag\_account\_alias) | Set tag based on account alias. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources. | `map(string)` | `{}` | no |
| <a name="input_target_arn"></a> [target\_arn](#input\_target\_arn) | Target ARN for eventbridge rule. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. See LICENSE for full details.