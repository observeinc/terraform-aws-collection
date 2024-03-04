resource "aws_s3_bucket" "this" {
  bucket_prefix = var.setup.short
  force_destroy = true
}

resource "aws_s3_access_point" "this" {
  count  = var.enable_access_point ? 1 : 0
  bucket = aws_s3_bucket.this.id
  name   = var.setup.short
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = length(aws_kms_key.this)
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}
