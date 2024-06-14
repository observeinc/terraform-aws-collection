resource "aws_cloudwatch_event_rule" "this" {
  count          = var.source_eventbridge_pattern != null ? 1 : 0
  name_prefix    = local.name_prefix
  description    = "Trigger copy for object created events"
  event_bus_name = "default"

  event_pattern = jsonencode(
    merge({
      source      = ["aws.s3"]
      detail-type = ["Object Created"],
    }, var.source_eventbridge_pattern),
  )
}

resource "aws_cloudwatch_event_target" "this" {
  count = var.source_eventbridge_pattern != null ? 1 : 0
  rule  = aws_cloudwatch_event_rule.this[0].name
  arn   = aws_sqs_queue.this.arn

  input_transformer {
    input_paths = {
      bucketName = "$.detail.bucket.name"
      objectKey  = "$.detail.object.key"
      objectSize = "$.detail.object.size"
    }
    input_template = <<-EOF
      {"copy": [{"uri": "s3://<bucketName>/<objectKey>", "size": <objectSize>}]}
    EOF
  }
}
