locals {
  enable_subscription = length(var.subscribed_log_group_matches) + length(var.subscribed_log_group_excludes) > 0
}

moved {
  from = module.observe_cloudwatch_logs_subscription
  to   = module.observe_cloudwatch_logs_subscription[0]
}

module "observe_cloudwatch_logs_subscription" {
  count   = local.enable_subscription ? 1 : 0
  source  = "observeinc/cloudwatch-logs-subscription/aws"
  version = "0.5.0"

  name             = var.log_subscription_name
  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix

  filter_name    = var.name
  filter_pattern = var.subscribed_log_group_filter_pattern

  log_group_matches = var.subscribed_log_group_matches

  log_group_excludes = var.subscribed_log_groups_excludes

  if var.subscribed_log_groups_exclude_observe_lambda {
     log_group_excludes = concat(
       log_group_excludes,
       # log groups managed by our module should be explicitly subscribed
       [aws_cloudwatch_log_group.group.name, "/aws/lambda/${var.name}"],
     )
  }

  # avoid racing with s3 bucket subscription
  depends_on = [
    module.observe_lambda_s3_bucket_subscription
  ]

  tags = var.tags
}
