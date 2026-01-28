resource "aws_cloudwatch_event_rule" "delivery" {
  name_prefix = var.name_prefix
  description = "Copy AWS Config files"

  event_pattern = jsonencode(
    {
      source = ["aws.config"]
      detail-type = [
        "Config Configuration History Delivery Status",
        "Config Configuration Snapshot Delivery Status"
      ]
      detail = {
        messageType = [
          "ConfigurationHistoryDeliveryCompleted",
          "ConfigurationSnapshotDeliveryCompleted",
        ]
      }
    },
  )

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "delivery" {
  rule = aws_cloudwatch_event_rule.delivery.name
  arn  = var.target_arn

  input_transformer {
    input_paths = {
      bucketName = "$.detail.s3bucket"
      objectKey  = "$.detail.s3ObjectKey"
    }
    input_template = <<EOF
      {"copy": [{"uri": "s3://<bucketName>/<objectKey>"}]}
    EOF
  }
}
