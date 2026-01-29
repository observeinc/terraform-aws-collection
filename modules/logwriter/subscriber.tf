module "subscriber" {
  count  = local.enable_subscription ? 1 : 0
  source = "../subscriber"

  name                            = var.name
  filter_name                     = var.filter_name
  filter_pattern                  = var.filter_pattern
  log_group_name_patterns         = var.log_group_name_patterns
  log_group_name_prefixes         = var.log_group_name_prefixes
  exclude_log_group_name_patterns = var.exclude_log_group_name_patterns
  wait_for_discovery_on_apply     = var.wait_for_discovery_on_apply
  cleanup_on_destroy              = var.cleanup_on_destroy
  discovery_rate                  = var.discovery_rate
  num_workers                     = var.num_workers
  cloudwatch_api_rate_limit       = coalesce(var.cloudwatch_api_rate_limit, 8)
  cloudwatch_api_burst            = coalesce(var.cloudwatch_api_burst, 16)
  sqs_batch_size                  = coalesce(var.sqs_batch_size, 5)
  sqs_maximum_concurrency         = coalesce(var.sqs_maximum_concurrency, 10)
  lambda_reserved_concurrency     = var.lambda_reserved_concurrency
  destination_iam_arn             = aws_iam_role.destination.arn
  firehose_arn                    = aws_kinesis_firehose_delivery_stream.delivery_stream.arn
  lambda_env_vars                 = var.lambda_env_vars
  lambda_memory_size              = var.lambda_memory_size
  lambda_timeout                  = var.lambda_timeout
  lambda_runtime                  = var.lambda_runtime
  debug_endpoint                  = var.debug_endpoint
  verbosity                       = var.verbosity
  code_uri                        = var.code_uri
  sam_release_version             = var.sam_release_version
  cloudwatch_log_kms_key          = var.cloudwatch_log_kms_key
  retention_in_days               = var.retention_in_days
  tags                            = var.tags
}
