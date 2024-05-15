resource "aws_lambda_function" "this" {
  function_name = var.name
  s3_bucket     = local.parsed_s3_uri["bucket"]
  s3_key        = local.parsed_s3_uri["key"]
  role          = aws_iam_role.this.arn
  architectures = ["arm64"]
  handler       = "bootstrap"
  runtime       = "provided.al2"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  environment {
    variables = merge({
      DESTINATION_URI             = local.destination_uri
      MAX_FILE_SIZE               = var.max_file_size
      CONTENT_TYPE_OVERRIDES      = join(",", [for o in var.content_type_overrides : "${o["pattern"]}=${o["content_type"]}"])
      SOURCE_BUCKET_NAMES         = join(",", var.source_bucket_names)
      OTEL_EXPORTER_OTLP_ENDPOINT = var.debug_endpoint
      OTEL_TRACES_EXPORTER        = var.debug_endpoint == "" ? "none" : "otlp"
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
