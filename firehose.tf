resource "aws_cloudwatch_log_group" "group" {
  name              = format("/aws/firehose/%s", var.name)
  retention_in_days = var.retention_in_days
}

module "observe_kinesis_firehose" {
  source = "github.com/observeinc/terraform-aws-kinesis-firehose?ref=v0.3.0"

  name             = var.name
  observe_url      = format("https://kinesis.collect.%s", var.observe_domain)
  observe_customer = var.observe_customer
  observe_token    = var.observe_token

  iam_name_prefix                  = local.name_prefix
  s3_delivery_bucket               = local.s3_bucket
  http_endpoint_buffering_interval = 60
  cloudwatch_log_group             = aws_cloudwatch_log_group.group
  tags                             = var.tags
}

module "observe_cloudwatch_metrics" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose?ref=v0.3.0//cloudwatch_metrics"
  name             = var.name
  iam_name_prefix  = local.name_prefix
  kinesis_firehose = module.observe_kinesis_firehose
}

module "observe_firehose_cloudwatch_logs_subscription" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose?ref=v0.3.0//cloudwatch_logs_subscription"
  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix
  log_group_names = concat(local.subscribed_log_group_names_firehose, [
    format("/aws/lambda/%s", var.name)
  ])
}
