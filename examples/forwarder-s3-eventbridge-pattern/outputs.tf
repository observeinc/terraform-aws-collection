output "source_bucket" {
  description = "Source bucket name to write objects to."
  value       = aws_s3_bucket.source.id
}

output "destination_bucket" {
  description = "Destination bucket name to read objects from."
  value       = aws_s3_bucket.destination.id
}
