locals {
  name_prefix = format("%s-", var.name)

  # normalize user input by appending trailing slash
  s3_exported_prefix = var.s3_exported_prefix != "" ? format("%s/", trimsuffix(var.s3_exported_prefix, "/")) : ""
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}
