output "bucket_arn" {
  description = "S3 Bucket arn"
  value       = aws_s3_bucket.this.arn
}

output "access_point" {
  description = "S3 access point where files are copied to"
  value       = one(aws_s3_access_point.this)
}


