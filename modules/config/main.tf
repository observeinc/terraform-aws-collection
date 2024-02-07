locals {
  all_supported          = length(var.include_resource_types) + length(var.exclude_resource_types) == 0
  include_resource_types = [for t in var.include_resource_types : t if t != "*"]
}
