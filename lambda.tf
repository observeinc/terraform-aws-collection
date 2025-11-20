module "observe_lambda" {
  source  = "observeinc/lambda/aws"
  version = "3.6.0"

  name             = var.name
  observe_domain   = var.observe_domain
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  iam_name_prefix  = local.name_prefix
  lambda_version   = var.lambda_version
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  tags             = var.tags

  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  lambda_s3_custom_rules        = var.lambda_s3_custom_rules
  lambda_envvars                = var.lambda_envvars
  kms_key                       = var.lambda_kms_key
  retention_in_days             = var.retention_in_days
  dead_letter_queue_destination = var.dead_letter_queue_destination
  vpc_config                    = var.lambda_vpc_config
}

module "observe_lambda_snapshot" {
  source  = "observeinc/lambda/aws//modules/snapshot"
  version = "3.6.0"

  lambda                           = module.observe_lambda
  eventbridge_name_prefix          = local.name_prefix
  eventbridge_schedule_expression  = var.snapshot_schedule_expression
  invoke_snapshot_on_start_enabled = var.invoke_snapshot_on_start_enabled
  action                           = var.snapshot_action
  include                          = var.snapshot_include
  exclude                          = var.snapshot_exclude
}
