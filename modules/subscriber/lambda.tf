resource "aws_lambda_event_source_mapping" "subscriber_sqs" {
  event_source_arn        = aws_sqs_queue.queue.arn
  function_name           = aws_lambda_function.subscriber.arn
  batch_size              = var.sqs_batch_size
  function_response_types = ["ReportBatchItemFailures"]

  scaling_config {
    maximum_concurrency = var.sqs_maximum_concurrency
  }
}

resource "aws_lambda_function" "subscriber" {
  function_name                  = var.name
  s3_bucket                      = local.parsed_s3_uri["bucket"]
  s3_key                         = local.parsed_s3_uri["key"]
  role                           = aws_iam_role.subscriber.arn
  handler                        = "bootstrap"
  runtime                        = var.lambda_runtime
  architectures                  = ["arm64"]
  memory_size                    = var.lambda_memory_size
  timeout                        = var.lambda_timeout
  reserved_concurrent_executions = var.lambda_reserved_concurrency

  environment {
    variables = merge({
      FILTER_NAME                     = var.filter_name
      FILTER_PATTERN                  = var.filter_pattern
      DESTINATION_ARN                 = var.firehose_arn
      LOG_GROUP_NAME_PREFIXES         = join(",", var.log_group_name_prefixes)
      LOG_GROUP_NAME_PATTERNS         = join(",", var.log_group_name_patterns)
      EXCLUDE_LOG_GROUP_NAME_PATTERNS = join(",", var.exclude_log_group_name_patterns)
      ROLE_ARN                        = var.destination_iam_arn
      QUEUE_URL                       = aws_sqs_queue.queue.id
      NUM_WORKERS                     = var.num_workers
      CLOUDWATCH_API_RATE_LIMIT       = var.cloudwatch_api_rate_limit
      CLOUDWATCH_API_BURST            = var.cloudwatch_api_burst
      OTEL_EXPORTER_OTLP_ENDPOINT     = var.debug_endpoint
      OTEL_TRACES_EXPORTER            = var.debug_endpoint == "" ? "none" : "otlp"
      VERBOSITY                       = var.verbosity
    }, var.lambda_env_vars)
  }

  tags = var.tags
}
