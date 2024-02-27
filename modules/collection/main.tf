locals {
  name_prefix = "${substr(var.name, 0, 36)}-"

  content_type_overrides = concat(
    var.logwriter != null ? [
      {
        pattern      = "^${aws_s3_bucket.this.id}/cloudwatchlogs"
        content_type = "application/x-aws-cloudwatchlogs"
      }
    ] : []
  , var.forwarder.content_type_overrides)

}
