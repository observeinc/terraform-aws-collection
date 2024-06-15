resource "aws_cloudwatch_event_rule" "this" {
  # Ideally we'd only gate this resource on the source bucket names, i.e:
  #
  #   count = length(var.source_bucket_names) > 0 ? 1 : 0
  #
  # This formulation would potentially depend on resources that can only be
  # determined at apply, so instead we adjust our event pattern to filter all
  # events out if no source buckets are provided.
  name_prefix    = local.name_prefix
  description    = "Trigger copy for object created events"
  event_bus_name = "default"

  event_pattern = jsonencode({
    "source"      = ["aws.s3"]
    "detail-type" = ["Object Created"],
    "detail.bucket.name" = [
      # list must have elements, so we introduce an empty match
      for name in concat([""], var.source_bucket_names) : { "wildcard" : name }
    ],
  })
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
    input_template = <<-EOF
      {"copy": [{"uri": "s3://<bucketName>/<objectKey>", "size": <objectSize>}]}
    EOF
  }
}
