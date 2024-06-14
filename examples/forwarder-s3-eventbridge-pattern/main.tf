locals {
  name        = basename(abspath(path.root))
  name_prefix = "${local.name}-"
}

resource "aws_s3_bucket" "source" {
  bucket_prefix = "${local.name_prefix}src-"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "source" {
  bucket      = aws_s3_bucket.source.id
  eventbridge = true
}

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
  name   = local.name

  destination = {
    bucket = aws_s3_bucket.destination.id
  }

  source_bucket_names = [aws_s3_bucket.source.id]

  source_eventbridge_pattern = {
    "detail.object.key" = [
      { "wildcard" = "*/foo/*" },
      { "wildcard" = "*/bar/*" },
    ]
  }
}
