resource "aws_s3_bucket" "direct" {
  bucket_prefix = "${local.name_prefix}direct-"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "direct" {
  bucket = aws_s3_bucket.direct.id
  queue {
    queue_arn = module.forwarder.queue_arn
    events    = ["s3:ObjectCreated:*"]
  }
}
