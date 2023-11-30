resource "aws_lambda_function" "this" {
  s3_bucket     = "aws-sam-cli-managed-default-samclisourcebucket-1d9p458evhgwf"
  s3_key        = "b67045a78524f85ad14fbcb7b3723126"
  handler       = "bootstrap"
  runtime       = "provided.al2"
  architectures = ["arm64"]

  function_name = var.name
  role          = aws_iam_role.this.arn
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  environment {
    variables = merge({
      FILTER_NAME             = var.filter_name
      FILTER_PATTERN          = var.filter_pattern
      DESTINATION_ARN         = var.destination_arn == null ? "" : var.destination_arn
      LOG_GROUP_NAME_PATTERNS = join(",", var.log_group_name_patterns)
      LOG_GROUP_NAME_PREFIXES = join(",", var.log_group_name_prefixes)
      ROLE_ARN                = var.role_arn == null ? "" : var.role_arn
      QUEUE_URL               = aws_sqs_queue.this.url
      VERBOSITY               = 9
      NUM_WORKERS             = var.num_workers
    }, var.lambda_env_vars)
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = format("/aws/lambda/%s", var.name)
  retention_in_days = var.retention_in_days
}

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn                   = aws_sqs_queue.this.arn
  enabled                            = true
  function_name                      = aws_lambda_function.this.arn
  batch_size                         = var.queue_batch_size
  maximum_batching_window_in_seconds = var.queue_maximum_batching_window_in_seconds
  function_response_types            = ["ReportBatchItemFailures"]
}
