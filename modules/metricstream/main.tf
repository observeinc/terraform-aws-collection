locals {
  name_prefix     = "${substr(var.name, 0, 37)}-"
  include_filters = var.include_filters
  exclude_filters = var.exclude_filters
}
