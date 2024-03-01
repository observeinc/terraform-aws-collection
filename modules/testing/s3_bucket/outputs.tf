output "arn" {
  description = "S3 Bucket arn"
  value       = aws_s3_bucket.this.arn
}

output "id" {
  description = "S3 Bucket name"
  value       = aws_s3_bucket.this.id
}

output "access_point" {
  description = "S3 access point where files are copied to"
  value       = one(aws_s3_access_point.this)
}

output "kms_key" {
  description = "KMS key used to encrypt bucket"
  value       = one(aws_kms_key.this)
}
