locals {
  eventbridge_rules = coalesce(var.eventbridge_rules, merge(
    {
      wildcard = {
        description = "Capture all events other than CloudTrail"
        event_pattern = jsonencode({
          detail-type = [{ anything-but = "AWS API Call via CloudTrail" }]
        })
      }
    },
    # Only include cloudtrail rule if not excluding all management events
    var.cloudtrail_exclude_all_management_event_sources ? {} : {
      cloudtrail = {
        description = "Capture all CloudTrail events"
        event_pattern = jsonencode({
          detail-type = ["AWS API Call via CloudTrail"]
          detail = {
            eventSource = [{ anything-but = var.cloudtrail_exclude_management_event_sources }]
          }
        })
      }
    }
  ))
}

resource "aws_cloudwatch_event_rule" "rules" {
  for_each      = local.eventbridge_rules
  name_prefix   = local.name_prefix
  description   = each.value.description
  event_pattern = each.value.event_pattern
  tags          = var.tags
}

# prior to 2.x, default rules were always applied
moved {
  from = module.observe_firehose_eventbridge
  to   = module.observe_firehose_eventbridge[0]
}

module "observe_firehose_eventbridge" {
  count   = length(aws_cloudwatch_event_rule.rules) > 0 ? 1 : 0
  source  = "observeinc/kinesis-firehose/aws//modules/eventbridge"
  version = "2.4.0"

  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = local.name_prefix
  rules            = aws_cloudwatch_event_rule.rules
  tags             = var.tags
}
