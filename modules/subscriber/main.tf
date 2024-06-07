locals {
  has_discovery_rate = var.discovery_rate != ""
  name_prefix        = "${substr(var.name, 0, 37)}-"

  code_uri      = var.code_uri != "" ? var.code_uri : module.samversion[0].code_uri
  parsed_s3_uri = regex("s3://(?P<bucket>[^/]+)/(?P<key>.+)", local.code_uri)
}

module "samversion" {
  count    = var.code_uri != "" ? 0 : 1
  source   = "../samversion"
  app      = "logwriter"
  function = "Subscriber"
  release  = var.sam_release_version
}
