resource "aws_cloudwatch_event_rule" "discovery" {
  count       = local.has_discovery_rate ? 1 : 0
  name_prefix = local.name_prefix
  description = "Subscribe new log groups. Requires CloudTrail in target region."
  state       = "ENABLED"

  event_pattern = <<-EOF
    {
      "source": ["aws.logs"],
      "detail-type": ["AWS API Call via CloudTrail"],
      "detail": {
        "eventSource": ["logs.amazonaws.com"],
        "eventName": ["CreateLogGroup"]
      }
    }
  EOF

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "discovery" {
  count = local.has_discovery_rate ? 1 : 0
  rule  = aws_cloudwatch_event_rule.discovery[0].name
  arn   = aws_sqs_queue.queue.arn

  input_transformer {
    input_paths = {
      logGroupName = "$.detail.requestParameters.logGroupName"
    }

    input_template = jsonencode({
      "subscribe" : {
        "logGroups" : [
          {
            "logGroupName" : "<logGroupName>"
          }
        ]
      }
    })
  }
}
