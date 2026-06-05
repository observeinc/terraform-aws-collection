resource "random_string" "run" {
  length  = 8
  special = false
  upper   = false
}

locals {
  example       = basename(abspath(path.root))
  run_suffix    = coalesce(var.test_run_id, random_string.run.result)
  run_short     = substr(local.run_suffix, max(0, length(local.run_suffix) - 8), 8)
  name          = "tac-${local.run_suffix}-${local.example}"
  name_prefix   = "${local.name}-"
  bucket_prefix = substr("t-${local.run_short}-${substr(local.example, 0, 22)}-", 0, 37)
}

# we'll write data to this bucket
resource "aws_s3_bucket" "destination" {
  bucket_prefix = substr("${trimsuffix(local.bucket_prefix, "-")}-dst-", 0, 37)
  force_destroy = true
}

module "forwarder" {
  # Prefer using the hashicorp registry:
  # source = "observeinc/collection/aws//modules/forwarder"
  # For validation purposes we will instead refer to a local version of the
  # module:
  source = "../..//modules/forwarder"

  name = local.name
  destination = {
    bucket = aws_s3_bucket.destination.id
    prefix = ""
  }
  source_bucket_names = ["${local.bucket_prefix}*"]
  source_object_keys  = ["*"]
}
