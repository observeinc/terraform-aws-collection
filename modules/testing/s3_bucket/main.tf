resource "aws_s3_bucket" "this" {
  bucket        = var.setup.short
  force_destroy = true
}

resource "aws_s3_access_point" "this" {
  count  = var.enable_access_point ? 1 : 0
  bucket = aws_s3_bucket.this.id
  name   = var.setup.short
}
