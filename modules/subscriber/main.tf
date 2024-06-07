locals {
  has_discovery_rate = var.discovery_rate != ""
  name_prefix        = "${substr(var.name, 0, 37)}-"

  code_uri      = var.code_uri != "" ? var.code_uri : yamldecode(module.sam_asset[0].body)["Resources"]["Subscriber"]["Properties"]["CodeUri"]
  parsed_s3_uri = regex("s3://(?P<bucket>[^/]+)/(?P<key>.+)", local.code_uri)
}

module "sam_asset" {
  count           = var.code_uri != "" ? 0 : 1
  source          = "../sam_asset"
  asset           = "logwriter.yaml"
  release_version = var.sam_release_version
}
