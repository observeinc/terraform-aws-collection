resource "aws_cloudwatch_event_rule" "oversized" {
  name_prefix = var.name_prefix
  description = "Copy AWS Config oversized files"

  event_pattern = jsonencode(
    {
      source = ["aws.config"]
      detail = {
        messageType = [
          "OversizedConfigurationItemChangeNotification"
        ]
      }
    },
  )
}

resource "aws_cloudwatch_event_target" "oversized" {
  rule = aws_cloudwatch_event_rule.delivery.name
  arn  = var.target_arn

  input_transformer {
    input_paths = {
      location = "$.detail.s3DeliverySummary.s3BucketLocation"
    }
    input_template = <<EOF
      {"copy": [{"uri": "s3://<location>"}]}
    EOF
  }
}
