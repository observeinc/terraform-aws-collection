output "observe_lambda" {
  description = "Observe Lambda module"
  value       = module.observe_lambda
}

output "observe_kinesis_firehose" {
  description = "Observe Kinesis Firehose module"
  value       = module.observe_kinesis_firehose
  sensitive   = true
}

output "bucket" {
  description = "S3 bucket subscribed to Observe Lambda"
  value       = local.s3_bucket
}
