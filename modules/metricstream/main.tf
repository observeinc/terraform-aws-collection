locals {
  account_id      = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.name
  name_prefix     = "${substr(var.name, 0, 37)}-"
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
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "sam_asset" {
  count           = local.use_recommended ? 1 : 0
  source          = "../sam_asset"
  asset           = "cloudwatchmetrics/filters/recommended.yaml"
  release_version = var.sam_release_version
}
