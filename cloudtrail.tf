resource "aws_cloudtrail" "trail" {
  name           = var.name
  s3_bucket_name = aws_s3_bucket.bucket.id
  s3_key_prefix  = var.s3_exported_prefix

  is_multi_region_trail = var.cloudtrail_is_multi_region_trail
  depends_on            = [aws_s3_bucket_policy.s3_policy]
}
