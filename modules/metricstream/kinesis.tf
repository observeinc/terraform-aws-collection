resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose.arn
    bucket_arn          = var.bucket_arn
    prefix              = "${var.prefix}AWSLogs/${local.account_id}/cloudwatchmetrics/${local.region}/${var.output_format}/"
    error_output_prefix = "${var.prefix}AWSLogs/${local.account_id}/cloudwatchmetrics/${local.region}/errors/"
    buffering_interval  = var.buffering_interval
    buffering_size      = var.buffering_size
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_log_stream.name
    }
  }
}
