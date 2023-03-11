locals {
  enable_subscription = length(var.subscribed_log_group_matches) + length(var.subscribed_log_group_excludes) > 0
  observe_log_groups  = [aws_cloudwatch_log_group.group.name, "/aws/lambda/${var.name}"]
}

moved {
  from = module.observe_cloudwatch_logs_subscription
  to   = module.observe_cloudwatch_logs_subscription[0]
}

resource "aws_iam_role" "observe_subscription_filter" {
  name_prefix        = local.name_prefix
  description        = "Role for subscription filters"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "logs.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
  EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "observe_subscription_filter" {
  role       = aws_iam_role.observe_subscription_filter.name
  policy_arn = module.observe_kinesis_firehose.firehose_iam_policy.arn
}

resource "aws_cloudwatch_log_subscription_filter" "observe_subscription_filter" {
  for_each = toset(local.observe_log_groups)

  name            = var.name
  destination_arn = module.observe_kinesis_firehose.firehose_delivery_stream.arn
  role_arn        = aws_iam_role.observe_subscription_filter.arn
  filter_pattern  = ""
  log_group_name  = each.key

  depends_on = [aws_iam_role_policy_attachment.observe_subscription_filter]
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
  log_group_excludes = concat(
    var.subscribed_log_group_excludes,
    # log groups managed by our module should be explicitly subscribed
    local.observe_log_groups
  )

  # avoid racing with s3 bucket subscription
  depends_on = [
    module.observe_lambda_s3_bucket_subscription
  ]

  tags = var.tags
}
