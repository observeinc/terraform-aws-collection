resource "aws_s3_bucket" "this" {
  bucket        = var.s3_bucket_name
  bucket_prefix = var.s3_bucket_name == null ? local.name_prefix : null
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id

  topic {
    topic_arn = aws_sns_topic.this.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id = "Expire uploaded objects"
    expiration {
      days = var.s3_bucket_lifecycle_expiration
    }
    status = "Enabled"
    filter {
      prefix = ""
    }
  }
}
