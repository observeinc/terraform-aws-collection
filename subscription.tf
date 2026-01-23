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
  version = "0.6.0"

  name             = var.log_subscription_name
  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix

  filter_name    = var.name
  filter_pattern = var.subscribed_log_group_filter_pattern

  log_group_matches = var.subscribed_log_group_matches
  log_group_excludes = concat(
    var.subscribed_log_group_excludes,
    # log groups managed by our module should be explicitly subscribed
    [aws_cloudwatch_log_group.group.name, local.lambda_log_group],
  )

  # avoid racing with s3 bucket subscription
  depends_on = [
    module.observe_lambda_s3_bucket_subscription
  ]

  tags = var.tags
}

locals {
  # TODO: output this from lambda module so we don't have to reverse-engineer it again here
  lambda_log_group = "/aws/lambda/${var.name}"
}

module "lambda_log_subscription" {
  count = var.lambda_subscribe_logs ? 1 : 0

  source  = "observeinc/kinesis-firehose/aws//modules/cloudwatch_logs_subscription"
  version = "2.4.0"

  kinesis_firehose = module.observe_kinesis_firehose
  log_group_names  = [local.lambda_log_group]
}
