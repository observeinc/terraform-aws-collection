locals {
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  enable_subscription = length(coalesce(var.log_group_name_patterns, var.log_group_name_prefixes, [])) > 0
  name_prefix         = "${substr(var.name, 0, 37)}-"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
