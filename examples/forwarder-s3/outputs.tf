output "direct_source" {
  description = "Source bucket subscribed directly"
  value       = aws_s3_bucket.direct.id
}

output "sns_source" {
  description = "Source bucket subscribed via SNS"
  value       = aws_s3_bucket.sns.id
}

output "eventbridge_source" {
  description = "Source bucket subscribed via eventbridge"
  value       = aws_s3_bucket.eventbridge.id
}


output "destination" {
  description = "Destination bucket objects are copied to."
  value       = aws_s3_bucket.destination.id
}
