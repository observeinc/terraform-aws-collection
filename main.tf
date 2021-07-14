locals {
  name_prefix                         = format("%s-", var.name)
  subscribed_log_group_names_lambda   = var.cloudwatch_logs_subscribe_to_lambda ? var.subscribed_log_group_names : []
  subscribed_log_group_names_firehose = var.cloudwatch_logs_subscribe_to_firehose ? var.subscribed_log_group_names : []

  # normalize user input by appending trailing slash
  s3_exported_prefix = var.s3_exported_prefix != "" ? format("%s/", trimsuffix(var.s3_exported_prefix, "/")) : ""
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
