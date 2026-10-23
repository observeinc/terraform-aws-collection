data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  has_discovery_rate  = var.discovery_rate != ""
  enable_provisioners = var.wait_for_discovery_on_apply || var.cleanup_on_destroy
  name_prefix         = "${substr(var.name, 0, 37)}-"

  # Releases up to 2.12.0 declare Subscriber as a SAM function with a CodeUri.
  # Later releases declare a plain AWS::Lambda::Function whose code location is
  # given by the LambdaS3BucketPrefix/LambdaS3Key parameter defaults.
  sam_template = var.code_uri != "" ? null : yamldecode(module.sam_asset[0].body)
  code_uri = var.code_uri != "" ? var.code_uri : try(
    local.sam_template["Resources"]["Subscriber"]["Properties"]["CodeUri"],
    "s3://${local.sam_template["Parameters"]["LambdaS3BucketPrefix"]["Default"]}-${data.aws_region.current.region}/${local.sam_template["Parameters"]["LambdaS3Key"]["Default"]}",
  )
  parsed_s3_uri = regex("s3://(?P<bucket>[^/]+)/(?P<key>.+)", local.code_uri)
}

module "sam_asset" {
  count           = var.code_uri != "" ? 0 : 1
  source          = "../sam_asset"
  asset           = "logwriter.yaml"
  release_version = var.sam_release_version
}
