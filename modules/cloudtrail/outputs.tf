output "bucket" {
  description = "S3 Bucket containing CloudTrail records"
  value       = aws_s3_bucket.this
}

output "topic" {
  description = "SNS Topic containing bucket notifications"
  value       = aws_sns_topic.this
}
