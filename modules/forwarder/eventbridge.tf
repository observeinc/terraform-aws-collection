resource "aws_cloudwatch_event_rule" "this" {
  name           = "${substr(var.name, 0, 37)}-"
  description    = "Trigger copy for object created events"
  event_bus_name = "default"

  event_pattern = jsonencode(
    {
      source      = ["aws.s3"]
      detail-type = ["Object Created"],
    },
  )
}

resource "aws_cloudwatch_event_target" "this" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = aws_sqs_queue.this.arn

  input_transformer {
    input_paths = {
      bucketName = "$.detail.bucket.name"
      objectKey  = "$.detail.object.key"
      objectSize = "$.detail.object.size"
    }
    input_template = <<EOF
      {"copy": [{"uri": "s3://<bucketName>/<objectKey>", "size": <objectSize>}]}
    EOF
  }
}
