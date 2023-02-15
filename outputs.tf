output "observe_lambda" {
  description = "Observe Lambda module"
  value       = module.observe_lambda
}

output "observe_kinesis_firehose" {
  description = "Observe Kinesis Firehose module"
  value       = module.observe_kinesis_firehose
}

output "bucket" {
  description = "S3 bucket subscribed to Observe Lambda"
  value       = local.s3_bucket
}

output "cloudtrail" {
  description = "AWS Cloudtrail. Currently this is experimental and only exposed for the test module."
  value       = aws_cloudtrail.trail
}
