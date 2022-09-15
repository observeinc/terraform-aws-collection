module "observe_lambda" {
  source  = "observeinc/lambda/aws"
  version = "1.1.0"

  name             = var.name
  observe_domain   = var.observe_domain
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  iam_name_prefix  = local.name_prefix
  lambda_version   = var.lambda_version
  tags             = var.tags

  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  lambda_s3_custom_rules        = var.lambda_s3_custom_rules
  lambda_envvars                = var.lambda_envvars
  retention_in_days             = var.retention_in_days
  dead_letter_queue_destination = var.dead_letter_queue_destination
}

module "observe_lambda_snapshot" {
  source  = "observeinc/lambda/aws//modules/snapshot"
  version = "1.1.0"

  lambda                          = module.observe_lambda
  eventbridge_name_prefix         = local.name_prefix
  eventbridge_schedule_expression = var.snapshot_schedule_expression
  include                         = var.snapshot_include
  exclude                         = var.snapshot_exclude
}
