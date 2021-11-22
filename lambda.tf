module "observe_lambda" {
  source = "github.com/observeinc/terraform-aws-lambda?ref=v0.8.0"

  name             = var.name
  observe_domain   = var.observe_domain
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  iam_name_prefix  = local.name_prefix
  lambda_version   = var.lambda_version
  tags             = var.tags

  lambda_s3_custom_rules        = var.lambda_s3_custom_rules
  lambda_envvars                = var.lambda_envvars
  retention_in_days             = var.retention_in_days
  dead_letter_queue_destination = var.dead_letter_queue_destination
}

module "observe_lambda_cloudwatch_logs_subscription" {
  source = "github.com/observeinc/terraform-aws-lambda?ref=v0.8.0//cloudwatch_logs_subscription"
  lambda = module.observe_lambda.lambda_function

  allow_all_log_groups = true

  statement_id_prefix = local.name_prefix
  log_group_names = concat(local.subscribed_log_group_names_lambda, [
    aws_cloudwatch_log_group.group.name
  ])

  # avoid racing with s3 bucket subscription
  depends_on = [module.observe_lambda_s3_bucket_subscription]
}

module "observe_lambda_snapshot" {
  source                  = "github.com/observeinc/terraform-aws-lambda?ref=v0.8.0//snapshot"
  lambda                  = module.observe_lambda
  eventbridge_name_prefix = local.name_prefix
  action                  = var.snapshot_action
  exclude                 = var.snapshot_exclude
}
