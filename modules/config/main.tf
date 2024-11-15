locals {
  all_supported          = length(local.include_resource_types) + length(var.exclude_resource_types) == 0
  include_resource_types = [for t in var.include_resource_types : t if t != "*"]
}

data "aws_partition" "current" {}
