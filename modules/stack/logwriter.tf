module "logwriter" {
  count  = var.logwriter != null ? 1 : 0
  source = "../logwriter"

  name       = "${var.name}-logwriter"
  bucket_arn = aws_s3_bucket.this.arn

  log_group_name_patterns         = var.logwriter.log_group_name_patterns
  log_group_name_prefixes         = var.logwriter.log_group_name_prefixes
  exclude_log_group_name_patterns = var.logwriter.exclude_log_group_name_patterns
  wait_for_discovery_on_apply     = var.logwriter.wait_for_discovery_on_apply
  cleanup_on_destroy              = var.logwriter.cleanup_on_destroy
  buffering_interval              = var.logwriter.buffering_interval
  buffering_size                  = var.logwriter.buffering_size
  filter_name                     = var.logwriter.filter_name
  filter_pattern                  = var.logwriter.filter_pattern
  num_workers                     = var.logwriter.num_workers
  cloudwatch_api_rate_limit       = var.logwriter.cloudwatch_api_rate_limit
  cloudwatch_api_burst            = var.logwriter.cloudwatch_api_burst
  sqs_batch_size                  = var.logwriter.sqs_batch_size
  sqs_maximum_concurrency         = var.logwriter.sqs_maximum_concurrency
  lambda_reserved_concurrency     = var.logwriter.lambda_reserved_concurrency
  discovery_rate                  = var.logwriter.discovery_rate
  lambda_memory_size              = var.logwriter.lambda_memory_size
  lambda_timeout                  = var.logwriter.lambda_timeout
  lambda_env_vars                 = var.logwriter.lambda_env_vars
  lambda_runtime                  = var.logwriter.lambda_runtime
  debug_endpoint                  = var.debug_endpoint
  verbosity                       = var.verbosity
  code_uri                        = var.logwriter.code_uri
  sam_release_version             = try(coalesce(var.logwriter.sam_release_version, var.sam_release_version), null)
  retention_in_days               = var.logwriter.retention_in_days
  cloudwatch_log_kms_key          = var.logwriter.cloudwatch_log_kms_key
  tags                            = var.tags

  depends_on = [aws_s3_bucket_notification.this]
}
