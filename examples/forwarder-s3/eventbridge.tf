resource "aws_s3_bucket" "eventbridge" {
  bucket_prefix = "${local.name_prefix}eventbridge-"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "eventbridge" {
  bucket      = aws_s3_bucket.eventbridge.id
  eventbridge = true
}
