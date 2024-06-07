locals {
  code_uri        = var.code_uri != "" ? var.code_uri : yamldecode(module.sam_asset[0].body)["Resources"]["Forwarder"]["Properties"]["CodeUri"]
  parsed_s3_uri   = regex("s3://(?P<bucket>[^/]+)/(?P<key>.+)", local.code_uri)
  destination_uri = var.destination.uri != "" ? var.destination.uri : "s3://${var.destination.bucket}/${var.destination.prefix}"
  name_prefix     = "${substr(var.name, 0, 37)}-"

  default_limits = startswith(local.destination_uri, "s3") ? {
    memory_size   = 128
    timeout       = 300
    max_file_size = 1024 * 1024 * 1024
    } : {
    memory_size   = 256
    timeout       = 300
    max_file_size = 100 * 1024 * 1024
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

module "sam_asset" {
  count           = var.code_uri != "" ? 0 : 1
  source          = "../sam_asset"
  asset           = "forwarder.yaml"
  release_version = var.sam_release_version
}
