resource "aws_cloudwatch_event_rule" "wildcard" {
  name_prefix = local.name_prefix
  description = "Capture all events in account"
  event_pattern = jsonencode({
    "account" : [data.aws_caller_identity.current.account_id]
  })
  tags = var.tags
}

module "observe_firehose_eventbridge" {
  source  = "observeinc/kinesis-firehose/aws//modules/eventbridge"
  version = "1.0.3"

  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix
  rules = [
    aws_cloudwatch_event_rule.wildcard,
  ]
  tags = var.tags
}
