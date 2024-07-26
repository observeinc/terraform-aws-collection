resource "aws_cloudtrail" "this" {
  name                  = var.name
  s3_bucket_name        = aws_s3_bucket.this.id
  s3_key_prefix         = var.s3_key_prefix
  is_multi_region_trail = var.is_multi_region_trail
  event_selector {
    exclude_management_event_sources = var.exclude_management_event_sources
  }

  depends_on = [aws_s3_bucket_policy.this]
}

