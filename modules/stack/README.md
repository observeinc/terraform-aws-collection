# Observe stack module

This module combines our log, metrics and configuration AWS collection modules
into a single standalone "stack".

This module:
- embeds the `forwarder` [module](../forwarder/README.md), which is responsible for forwarding data to Observe. 
- creates a collection S3 bucket. This bucket is subscribed to the `forwarder`. As a result, any data written to this bucket will be sent to Observe.
- creates a collection SNS topic. This topic is subscribed to the `forwarder`. Any message sent to this topic will be sent to Observe.

You may optionally enable modules for collecting data from AWS sources. These modules will all write directly to the collection S3 bucket.

## Configuring forwarding

In order to install the `stack` module, you must provide a destination. The module supports two backend schemes.

### Filedrop

To configure a Filedrop backend, you must first create a Filedrop using the `observe` provider, and then pass it in directly as a destination. The following snippet is extracted from the [provided example](../../examples/stack-filedrop/README.md):


```terraform
data "aws_caller_identity" "current" {}

data "observe_workspace" "default" {
  name = "Default"
}

resource "observe_datastream" "this" {
  workspace = data.observe_workspace.default.oid
  name      = local.name
}

resource "observe_filedrop" "this" {
  workspace  = data.observe_workspace.default.oid
  datastream = observe_datastream.this.oid

  config {
    provider {
      aws {
        region   = "us-west-2"
        role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.name}"
      }
    }
  }
}

module "stack" {
  source = "observeinc/collection/aws//modules/stack"

  name        = local.name
  destination = observe_filedrop.this.endpoint[0].s3[0]
}
```

### HTTPS

To configure an HTTPS backend, you can create a datastream token and reference the collection URL. 
 The following snippet is extracted from the [provided example](../../examples/stack-http/README.md):

```terraform
locals {
  token               = nonsensitive(observe_datastream_token.this.secret)
  collection_endpoint = trim(data.observe_ingest_info.this.collect_url, "https://")
}

data "observe_workspace" "default" {
  name = "Default"
}

resource "observe_datastream" "this" {
  workspace = data.observe_workspace.default.oid
  name      = local.name
}

resource "observe_datastream_token" "this" {
  datastream = observe_datastream.this.oid
  name       = local.name
}

data "observe_ingest_info" "this" {}

module "stack" {
  source = "observeinc/collection/aws//modules/stack"

  name = local.name
  destination = {
    uri = "https://${local.token}@${local.collection_endpoint}/v1/http"
  }
}
```

## Configuring AWS sources

You may optionally enable different submodules which are exposed as part of the `stack` parent module. Configuration of these modules is always explicitly gated on the presence of a variable.

For example, to instantiate the `logwriter` [module](../logwriter/README.md), you must specify a `logwriter` object:

```terraform
module "collection_stack" {
  source      = "observeinc/collection/aws//modules/stack"

  ...
  # installs the logwriter module
  logwriter = {}
}
```

Any variable defined within the object will be passed directly to submodule. For example, we can enable automatic log subscription by enabled `logwriter` and passing in `log_group_name_patterns`:

```terraform
module "collection_stack" {
  source      = "observeinc/collection/aws//modules/stack"

  ...
  # installs the logwriter module
  logwriter = {
    # enables automatic subscription for all log groups
    log_group_name_patterns = ["*"]
  }
}
```

You can additionally configure other submodules in this manner:
- the `config` [module](../config/README.md) installs [AWS Config](https://aws.amazon.com/config/) collection. 
- the `configsubscription` [module](../configsubscription/README.md) enables subscribing to a pre-existing [AWS Config](https://aws.amazon.com/config/) install. 
- the `metricstream` [module](../metricstream/README.md) enables [AWS Cloudwatch Metrics Stream](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metric-Streams.html) collection. 

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
| <a name="input_forwarder"></a> [forwarder](#input\_forwarder) | Variables for forwarder module. | <pre>object({<br>    source_bucket_names                      = optional(list(string), [])<br>    source_object_keys                       = optional(list(string))<br>    source_topic_arns                        = optional(list(string), [])<br>    content_type_overrides                   = optional(list(object({ pattern = string, content_type = string })), [])<br>    max_file_size                            = optional(number)<br>    lambda_memory_size                       = optional(number)<br>    lambda_timeout                           = optional(number)<br>    lambda_env_vars                          = optional(map(string))<br>    retention_in_days                        = optional(number)<br>    queue_max_receive_count                  = optional(number)<br>    queue_delay_seconds                      = optional(number)<br>    queue_message_retention_seconds          = optional(number)<br>    queue_batch_size                         = optional(number)<br>    queue_maximum_batching_window_in_seconds = optional(number)<br>    code_uri                                 = optional(string)<br>    sam_release_version                      = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_logwriter"></a> [logwriter](#input\_logwriter) | Variables for AWS CloudWatch Logs collection. | <pre>object({<br>    log_group_name_patterns         = optional(list(string))<br>    log_group_name_prefixes         = optional(list(string))<br>    exclude_log_group_name_prefixes = optional(list(string))<br>    buffering_interval              = optional(number)<br>    buffering_size                  = optional(number)<br>    filter_name                     = optional(string)<br>    filter_pattern                  = optional(string)<br>    num_workers                     = optional(number)<br>    discovery_rate                  = optional(string, "24 hours")<br>    lambda_memory_size              = optional(number)<br>    lambda_timeout                  = optional(number)<br>    code_uri                        = optional(string)<br>    sam_release_version             = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_metricstream"></a> [metricstream](#input\_metricstream) | Variables for AWS CloudWatch Metrics Stream collection. | <pre>object({<br>    include_filters     = optional(list(object({ namespace = string, metric_names = optional(list(string)) })))<br>    exclude_filters     = optional(list(object({ namespace = string, metric_names = optional(list(string)) })))<br>    buffering_interval  = optional(number)<br>    buffering_size      = optional(number)<br>    sam_release_version = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of role. Since this name must be unique within the<br>account, it will be reused for most of the resources created by this<br>module. | `string` | n/a | yes |
| <a name="input_s3_bucket_lifecycle_expiration"></a> [s3\_bucket\_lifecycle\_expiration](#input\_s3\_bucket\_lifecycle\_expiration) | Expiration in days for S3 objects in collection bucket | `number` | `4` | no |
| <a name="input_sam_release_version"></a> [sam\_release\_version](#input\_sam\_release\_version) | Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps. | `string` | `null` | no |
| <a name="input_verbosity"></a> [verbosity](#input\_verbosity) | Logging verbosity for Lambda. Highest log verbosity is 9. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | S3 bucket subscribed to forwarder |
| <a name="output_config"></a> [config](#output\_config) | Config module |
| <a name="output_configsubscription"></a> [configsubscription](#output\_configsubscription) | ConfigSubscription module |
| <a name="output_forwarder"></a> [forwarder](#output\_forwarder) | Forwarder module |
| <a name="output_logwriter"></a> [logwriter](#output\_logwriter) | LogWriter module |
| <a name="output_metricstream"></a> [metricstream](#output\_metricstream) | MetricStream module |
| <a name="output_topic"></a> [topic](#output\_topic) | SNS topic subscribed to forwarder |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
