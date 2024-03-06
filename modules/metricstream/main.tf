locals {
  account_id      = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.name
  name_prefix     = "${substr(var.name, 0, 37)}-"
  include_filters = var.include_filters
  exclude_filters = var.exclude_filters
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
