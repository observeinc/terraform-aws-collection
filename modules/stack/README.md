# Observe stack module

This module combines our log, metrics and configuration AWS collection modules into a single standalone "stack".

## Usage

This is a minimal example for setting up the stack module:

- create an `observe_datastream`
- create an `observe_filedrop`. You must provide an ARN for a role that does not yet exist.
- instantiate the module with the `observe_filedrop` and the `name` of the role you used in the previous step.

```hcl
data "observe_workspace" "default" {
  name = "Default"
}

resource "random_pet" "this" {}

data "observe_datastream" "this" {
  workspace = data.observe_workspace.default.oid
  name      = random_pet.this.id
}

resource "observe_filedrop" "this" {
  workspace  = data.observe_workspace.default.oid
  datastream = observe_datastream.this.oid
  config {
    provider {
      aws {
        region   = "us-west-2"
        role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${random_pet.this.id}"
      }
    }
  }
}

module "collection_stack" {
  source      = "observeinc/collection/aws//modules/stack"
  name        = random_pet.this.id

  destination = observe_filedrop.this.endpoint[0].s3[0]

  # Install AWS Config and collect all resources
  config = {
    include_resource_types  = ["*"]
  }

  # Subscribe to all CloudWatch Log Groups
  logwriter = {
    log_group_name_patterns = ["*"]  
  }

  # Export all CloudWatch Metrics
  metricstream = {}
}

```

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
| <a name="module_config"></a> [config](#module\_config) | ../config | n/a |
| <a name="module_configsubscription"></a> [configsubscription](#module\_configsubscription) | ../configsubscription | n/a |
| <a name="module_forwarder"></a> [forwarder](#module\_forwarder) | ../forwarder | n/a |
| <a name="module_logwriter"></a> [logwriter](#module\_logwriter) | ../logwriter | n/a |
| <a name="module_metricstream"></a> [metricstream](#module\_metricstream) | ../metricstream | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | Variables for AWS Config collection. | <pre>object({<br>    include_resource_types        = list(string)<br>    exclude_resource_types        = optional(list(string))<br>    delivery_frequency            = optional(string)<br>    include_global_resource_types = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_configsubscription"></a> [configsubscription](#input\_configsubscription) | Variables for AWS Config subscription. | <pre>object({<br>    delivery_bucket_name = string<br>  })</pre> | `null` | no |
| <a name="input_debug_endpoint"></a> [debug\_endpoint](#input\_debug\_endpoint) | Endpoint to send debugging telemetry to. Sets OTEL\_EXPORTER\_OTLP\_ENDPOINT environment variable for supported lambda functions. | `string` | `null` | no |
| <a name="input_destination"></a> [destination](#input\_destination) | Destination filedrop | <pre>object({<br>    arn    = optional(string, "")<br>    bucket = optional(string, "")<br>    prefix = optional(string, "")<br>    # exclusively for backward compatible HTTP endpoint<br>    uri = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_forwarder"></a> [forwarder](#input\_forwarder) | Variables for forwarder module. | <pre>object({<br>    source_bucket_names                      = optional(list(string), [])<br>    source_topic_arns                        = optional(list(string), [])<br>    content_type_overrides                   = optional(list(object({ pattern = string, content_type = string })), [])<br>    max_file_size                            = optional(number)<br>    lambda_memory_size                       = optional(number)<br>    lambda_timeout                           = optional(number)<br>    lambda_env_vars                          = optional(map(string))<br>    retention_in_days                        = optional(number)<br>    queue_max_receive_count                  = optional(number)<br>    queue_delay_seconds                      = optional(number)<br>    queue_message_retention_seconds          = optional(number)<br>    queue_batch_size                         = optional(number)<br>    queue_maximum_batching_window_in_seconds = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_logwriter"></a> [logwriter](#input\_logwriter) | Variables for AWS CloudWatch Logs collection. | <pre>object({<br>    log_group_name_patterns = optional(list(string))<br>    log_group_name_prefixes = optional(list(string))<br>    buffering_interval      = optional(number)<br>    buffering_size          = optional(number)<br>    filter_name             = optional(string)<br>    filter_pattern          = optional(string)<br>    num_workers             = optional(number)<br>    discovery_rate          = optional(string, "24 hours")<br>    lambda_memory_size      = optional(number)<br>    lambda_timeout          = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_metricstream"></a> [metricstream](#input\_metricstream) | Variables for AWS CloudWatch Metrics Stream collection. | <pre>object({<br>    include_filters    = optional(list(object({ namespace = string, metric_names = optional(list(string)) })))<br>    exclude_filters    = optional(list(object({ namespace = string, metric_names = optional(list(string)) })))<br>    buffering_interval = optional(number)<br>    buffering_size     = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of role. Since this name must be unique within the<br>account, it will be reused for most of the resources created by this<br>module. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
