resource "aws_cloudwatch_event_rule" "wildcard" {
  name_prefix = local.name_prefix
  description = "Capture all events except CloudTrail in account"
  event_pattern = jsonencode({
    "account" : [data.aws_caller_identity.current.account_id]
    "detail-type" : [{ "anything-but" : "AWS API Call via CloudTrail" }]
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "cloudtrail" {
  count       = var.cloudtrail_enable ? 1 : 0
  name_prefix = local.name_prefix
  description = "Capture all CloudTrail events in account"
  event_pattern = jsonencode({
    "account" : [data.aws_caller_identity.current.account_id]
    "detail-type" : ["AWS API Call via CloudTrail"]
    "detail" : {
      "eventSource" : [{ "anything-but" : var.cloudtrail_exclude_management_event_sources }]
    }
  })
  tags = var.tags
}

module "observe_firehose_eventbridge" {
  source  = "observeinc/kinesis-firehose/aws//modules/eventbridge"
  version = "1.0.3"

  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix
  rules = concat(
    [aws_cloudwatch_event_rule.wildcard],
    aws_cloudwatch_event_rule.cloudtrail,
  )
  tags = var.tags
}
