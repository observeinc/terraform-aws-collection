resource "aws_s3_bucket" "eventbridge" {
  bucket_prefix = substr("${trimsuffix(local.bucket_prefix, "-")}-eb-", 0, 37)
  force_destroy = true
}

resource "aws_s3_bucket_notification" "eventbridge" {
  bucket      = aws_s3_bucket.eventbridge.id
  eventbridge = true
}
