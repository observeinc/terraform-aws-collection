resource "aws_cloudwatch_event_rule" "change" {
  name_prefix = var.name_prefix
  description = "Forward AWS Config change notifications"

  event_pattern = jsonencode(
    {
      source = ["aws.config"]
      detail-type = [
        "Config Configuration Item Change"
      ]
    },
  )

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "change" {
  rule = aws_cloudwatch_event_rule.change.name
  arn  = var.target_arn
}
