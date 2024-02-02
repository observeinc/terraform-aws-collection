locals {
  has_discovery_rate = var.discovery_rate != ""
  name_prefix        = "${substr(var.name, 0, 37)}-"
  s3_uri             = one([for item in csvdecode(file("${path.module}/uris.csv")) : item["code_uri"] if item["region"] == data.aws_region.current.name])
  parsed_s3_uri      = regex("s3://(?P<bucket>[^/]+)/(?P<key>.+)", local.s3_uri)
}

data "aws_region" "current" {}
