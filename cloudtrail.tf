resource "aws_cloudtrail" "trail" {
  name                  = var.name
  s3_bucket_name        = local.s3_bucket.id
  s3_key_prefix         = trimsuffix(local.s3_exported_prefix, "/")
  is_multi_region_trail = var.cloudtrail_is_multi_region_trail
  kms_key_id            = var.kms_key_id
}
