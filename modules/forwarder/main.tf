locals {
  s3_uri        = one([for item in csvdecode(file("${path.module}/uris.csv")) : item["code_uri"] if item["region"] == data.aws_region.current.name])
  parsed_s3_uri = regex("s3://(?P<bucket>[^/]+)/(?P<key>.+)", local.s3_uri)
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
