resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name              = "/aws/firehose/${var.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "s3logs"
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
}

resource "aws_cloudwatch_metric_stream" "main" {
  name_prefix   = local.name_prefix
  role_arn      = aws_iam_role.metric_stream.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.this.arn
  output_format = var.output_format

  dynamic "include_filter" {
    for_each = local.filter.include_filters
    content {
      namespace    = include_filter.value.namespace
      metric_names = include_filter.value.metric_names
    }
  }

  dynamic "exclude_filter" {
    for_each = local.filter.exclude_filters
    content {
      namespace    = exclude_filter.value.namespace
      metric_names = exclude_filter.value.metric_names
    }
  }

  tags = var.tags
}
