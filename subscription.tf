module "observe_cloudwatch_logs_subscription" {
  source           = "observeinc/cloudwatch-logs-subscription/aws"
  version          = "0.4.0"
  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix

  filter_name    = var.name
  filter_pattern = var.subscribed_log_group_filter_pattern

  log_group_matches = concat(
    [aws_cloudwatch_log_group.group.name, format("/aws/lambda/%s", var.name)], # Note: Data from firehose will go to itself. There is a cycle.
    var.subscribed_log_group_matches,
  )
  log_group_excludes = var.subscribed_log_group_excludes

  # avoid racing with s3 bucket subscription
  depends_on = [
    module.observe_lambda_s3_bucket_subscription
  ]

  tags = var.tags
}
