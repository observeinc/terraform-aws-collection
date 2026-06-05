resource "aws_s3_bucket" "direct" {
  bucket_prefix = substr("${trimsuffix(local.bucket_prefix, "-")}-dir-", 0, 37)
  force_destroy = true
}

resource "aws_s3_bucket_notification" "direct" {
  bucket = aws_s3_bucket.direct.id
  queue {
    queue_arn = module.forwarder.queue_arn
    events    = ["s3:ObjectCreated:*"]
  }
}
