locals {
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = data.aws_region.current.name
  enable_subscription         = anytrue([local.has_log_group_name_patterns, local.has_log_group_name_prefixes])
  has_log_group_name_patterns = var.log_group_name_patterns != null ? join(",", var.log_group_name_patterns) != "" : false
  has_log_group_name_prefixes = var.log_group_name_prefixes != null ? join(",", var.log_group_name_prefixes) != "" : false
  name_prefix                 = "${substr(var.name, 0, 37)}-"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
