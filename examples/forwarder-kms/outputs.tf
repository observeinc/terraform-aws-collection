output "source_bucket" {
  description = "Source bucket name to write objects to. This bucket is encrypted using KMS."
  value       = aws_s3_bucket.source
}

output "datastream" {
  description = "Observe Datastream containing data copied from source bucket."
  value       = observe_datastream.this
}
