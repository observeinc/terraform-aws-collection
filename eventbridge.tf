resource "aws_cloudwatch_event_rule" "wildcard" {
  name_prefix = local.name_prefix
  description = "Capture all events in account"
  event_pattern = jsonencode({
    "account" : [data.aws_caller_identity.current.account_id]
  })
}

module "observe_firehose_eventbridge" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose?ref=v0.4.0//eventbridge"
  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix
  rules = [
    aws_cloudwatch_event_rule.wildcard,
  ]
}
