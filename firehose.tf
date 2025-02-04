resource "aws_cloudwatch_log_group" "group" {
  name              = format("/aws/firehose/%s", var.name)
  retention_in_days = var.retention_in_days
}

module "observe_kinesis_firehose" {
  source  = "observeinc/kinesis-firehose/aws"
  version = "2.3.0"

  name             = var.name
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_domain   = var.observe_domain

  iam_name_prefix                  = local.name_prefix
  s3_delivery_bucket               = local.s3_bucket
  http_endpoint_buffering_interval = 60
  cloudwatch_log_group             = aws_cloudwatch_log_group.group
  tags                             = var.tags
}

# prior to 2.x, metrics stream was always configured
moved {
  from = module.observe_cloudwatch_metrics
  to   = module.observe_cloudwatch_metrics[0]
}

module "observe_cloudwatch_metrics" {
  count   = contains(var.cloudwatch_metrics_exclude_filters, "*") ? 0 : 1
  source  = "observeinc/kinesis-firehose/aws//modules/cloudwatch_metrics"
  version = "2.3.0"

  name             = var.name
  iam_name_prefix  = local.name_prefix
  kinesis_firehose = module.observe_kinesis_firehose
  include_filters  = var.cloudwatch_metrics_include_filters
  exclude_filters  = var.cloudwatch_metrics_exclude_filters
}
