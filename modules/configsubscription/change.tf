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
}

resource "aws_cloudwatch_event_target" "change" {
  rule = aws_cloudwatch_event_rule.delivery.name
  arn  = var.target_arn
}
