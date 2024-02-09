resource "aws_s3_bucket" "this" {
  bucket_prefix = local.name_prefix
  force_destroy = true
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
    id = "Expire daily"
    expiration {
      days = 1
    }
    status = "Enabled"
  }
}
