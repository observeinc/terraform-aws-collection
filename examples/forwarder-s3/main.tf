locals {
  name        = basename(abspath(path.root))
  name_prefix = "${local.name}-"
}

# we'll write data to this bucket
resource "aws_s3_bucket" "destination" {
  bucket_prefix = "${local.name_prefix}dst-"
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
  source_bucket_names = ["${local.name_prefix}*"]
  source_object_keys  = ["*"]
}
