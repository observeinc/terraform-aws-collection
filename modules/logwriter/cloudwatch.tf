moved {
  from = aws_cloudwatch_log_group.firehose_log_group
  to   = aws_cloudwatch_log_group.firehose
}

moved {
  from = aws_cloudwatch_log_stream.firehose_log_stream
  to   = aws_cloudwatch_log_stream.firehose
}

resource "aws_cloudwatch_log_group" "firehose" {
  name              = "/aws/firehose/${var.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "firehose" {
  name           = "s3logs"
  log_group_name = aws_cloudwatch_log_group.firehose.name
}
