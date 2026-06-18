locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.region
  name_prefix = "${substr(var.name, 0, 37)}-"
  # Lambda function names are capped at 64 chars; var.name allows up to 64, so
  # bound it before appending the "-tag" suffix.
  metrictag_name  = "${substr(var.name, 0, 60)}-tag"
  use_recommended = var.include_filters == null && var.exclude_filters == null
  recommended     = local.use_recommended ? yamldecode(module.sam_asset[0].body) : null
  filter = local.use_recommended ? {
    # must convert from cloudformation CamelCase to terraform snake_case when falling back to recommended filter
    include_filters = try([for v in local.recommended["IncludeFilters"] : { namespace = v.Namespace, metric_names = v.MetricNames }], [])
    exclude_filters = try([for v in local.recommended["ExcludeFilters"] : { namespace = v.Namespace, metric_names = v.MetricNames }], [])
    } : {
    include_filters = coalesce(var.include_filters, [])
    exclude_filters = coalesce(var.exclude_filters, [])
  }

  # Resolve the metrictag Lambda code location. Mirrors the forwarder/subscriber
  # code_uri pattern, but reads the published metricstream.yaml parameter
  # defaults since metrictag is a parameterized AWS::Lambda::Function rather than
  # a SAM CodeUri. Only evaluated when tag enrichment is enabled.
  metrictag_params = length(module.metrictag_asset) > 0 ? yamldecode(module.metrictag_asset[0].body)["Parameters"] : null
  metrictag_code_uri = var.enable_tag_enrichment ? (
    var.metrictag_code_uri != "" ? var.metrictag_code_uri : "s3://${local.metrictag_params["LambdaS3BucketPrefix"]["Default"]}-${local.region}/${local.metrictag_params["MetricTagLambdaS3Key"]["Default"]}"
  ) : ""
  metrictag_s3 = var.enable_tag_enrichment ? regex("s3://(?P<bucket>[^/]+)/(?P<key>.+)", local.metrictag_code_uri) : null
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "sam_asset" {
  count           = local.use_recommended ? 1 : 0
  source          = "../sam_asset"
  asset           = "cloudwatchmetrics/filters/recommended.yaml"
  release_version = var.sam_release_version
}

module "metrictag_asset" {
  count           = var.enable_tag_enrichment && var.metrictag_code_uri == "" ? 1 : 0
  source          = "../sam_asset"
  asset           = "metricstream.yaml"
  release_version = var.sam_release_version
}
