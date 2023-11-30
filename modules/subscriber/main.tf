locals {
  name_prefix = "${var.name}-"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
