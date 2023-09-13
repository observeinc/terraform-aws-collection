resource "aws_cloudwatch_event_rule" "this" {
  name_prefix    = "${var.name}-"
  description    = "EventBridge rule to trigger Lambda function"
  event_bus_name = "default"

  event_pattern = jsonencode(merge(
    {
      source      = ["aws.s3"]
      detail-type = ["Object Created"],
    },
    local.read_any ? {} : {
      resources = var.bucket_arns
    })
  )
}

resource "aws_cloudwatch_event_target" "this" {
  arn  = aws_lambda_function.this.arn
  rule = aws_cloudwatch_event_rule.this.name
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = var.name
  source_arn    = aws_cloudwatch_event_rule.this.arn
  depends_on    = [aws_lambda_function.this]
}
