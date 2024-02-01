# Observe AWS Logwriter

This app ingests logs from various sources into Observe. This app can be configured to ingest from a fixed set of Cloudwatch log groups or it can be configured with a subscriber lambda that periodically searches for new log groups to include.

## Usage

This is a minimal example for setting up a logwriter:

- create an `observe_datastream`
- create an `observe_filedrop`. You must provide an ARN for a role that does not yet exist.
- instantiate the logwriter module with the `observe_filedrop` and the `name` of the role you used in the previous step.

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

module "logwriter" {
  name                    = random_pet.this.id
  bucket_arn              = observe_filedrop.this.endpoint[0].s3[0]
  filter_name             = "${random_pet.this.id}-filter"
  num_workers             = "1"
  log_group_name_prefixes = ["*"]
  discovery_rate          = "10 minutes"
}

# Example static cloudwatch log subscription filter that ingests logs from the subscriber lambda
resource "aws_cloudwatch_log_subscription_filter" "lambda_cloudwatch_subscription_filter" {
  name            = "${random_pet.this.id}-logfilter"
  role_arn        = module.logwriter.destination_iam_policy
  log_group_name  = "/aws/lambda/${random_pet.this.id}"
  filter_pattern  = ""
  destination_arn = module.logwriter.firehose_arn
  distribution    = "Random"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subscriber"></a> [subscriber](#module\_subscriber) | ../subscriber | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.firehose_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.firehose_log_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_iam_role.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kinesis_firehose_delivery_stream.delivery_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_iam_policy_document.destination_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.destination_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_s3writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | S3 Bucket ARN to write log records to. | `string` | n/a | yes |
| <a name="input_buffering_interval"></a> [buffering\_interval](#input\_buffering\_interval) | Buffer incoming data for the specified period of time, in seconds, before<br>delivering it to S3. | `number` | `60` | no |
| <a name="input_buffering_size"></a> [buffering\_size](#input\_buffering\_size) | Buffer incoming data to the specified size, in MiBs, before delivering it<br>to S3. | `number` | `1` | no |
| <a name="input_discovery_rate"></a> [discovery\_rate](#input\_discovery\_rate) | EventBridge rate expression for periodically triggering discovery. If not set, no eventbridge rules are configured. | `string` | `null` | no |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Subscription filter name. Existing filters that have this name as a prefix will be removed. | `string` | `null` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | Subscription filter pattern. | `string` | `null` | no |
| <a name="input_lambda_env_vars"></a> [lambda\_env\_vars](#input\_lambda\_env\_vars) | Environment variables to be passed into lambda. | `map(string)` | `null` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for lambda function. | `number` | `null` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout in seconds for lambda function. | `number` | `null` | no |
| <a name="input_log_group_name_patterns"></a> [log\_group\_name\_patterns](#input\_log\_group\_name\_patterns) | List of patterns as strings. We will only subscribe to log groups that have names matching one of the provided strings based on strings based on a case-sensitive substring search. To subscribe to all log groups, use the wildcard operator *. | `list(string)` | `null` | no |
| <a name="input_log_group_name_prefixes"></a> [log\_group\_name\_prefixes](#input\_log\_group\_name\_prefixes) | List of prefixes as strings. The lambda function will only apply to log groups that start with a provided string. To subscribe to all log groups, use the wildcard operator *. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of role. Since this name must be unique within the<br>account, it will be reused for most of the resources created by this<br>module. | `string` | n/a | yes |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | Maximum number of concurrent workers when processing log groups. | `number` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix to write log records to. | `string` | `"observe"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_iam_policy"></a> [destination\_iam\_policy](#output\_destination\_iam\_policy) | Firehose destination iam policy |
| <a name="output_firehose"></a> [firehose](#output\_firehose) | Kinesis Firehose Delivery Stream ARN |
| <a name="output_function"></a> [function](#output\_function) | Lambda Function ARN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
