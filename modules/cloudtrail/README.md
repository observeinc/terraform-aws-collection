# Observe AWS CloudTrail

This module creates an [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) trail along with the supporting infrastructure needed to deliver trail records to Observe:

- An S3 bucket to store CloudTrail log files
- An SNS topic that receives S3 bucket notifications when new log files arrive

> **Warning:** AWS enforces a hard quota of **5 trails per region per account**. Before enabling this module, verify how many trails already exist in the target region. If you already have CloudTrail enabled, consider using your existing trail and routing its S3 bucket to Observe instead of creating a new one.

## Usage

```hcl
module "cloudtrail" {
  source = "observeinc/collection/aws//modules/cloudtrail"

  name = "observe-cloudtrail"
}
```

To enable multi-region trail collection:

```hcl
module "cloudtrail" {
  source = "observeinc/collection/aws//modules/cloudtrail"

  name                  = "observe-cloudtrail"
  is_multi_region_trail = true
}
```

By default, management events from KMS and RDS Data API are excluded. To capture all management events:

```hcl
module "cloudtrail" {
  source = "observeinc/collection/aws//modules/cloudtrail"

  name                             = "observe-cloudtrail"
  exclude_management_event_sources = []
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.s3_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exclude_management_event_sources"></a> [exclude\_management\_event\_sources](#input\_exclude\_management\_event\_sources) | A list of management event sources to exclude from CloudTrail.<br/>To capture all CloudTrail management events, leave this as an empty list ([]). | `list(string)` | <pre>[<br/>  "kms.amazonaws.com",<br/>  "rdsdata.amazonaws.com"<br/>]</pre> | no |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input\_is\_multi\_region\_trail) | Whether the trail is created in the current region or in all regions | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Trail name. Also used as bucket prefix | `string` | n/a | yes |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | Optional prefix to write CloudTrail records to. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | S3 Bucket containing CloudTrail records |
| <a name="output_topic"></a> [topic](#output\_topic) | SNS Topic containing bucket notifications |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.