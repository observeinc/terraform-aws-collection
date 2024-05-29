output "subscriber" {
  description = "Subscriber module"
  value       = one(module.subscriber)
}

output "log_group" {
  description = "Kinesis Firehose Log Group"
  value       = aws_cloudwatch_log_group.firehose
}

output "firehose_arn" {
  description = "Kinesis Firehose Delivery Stream ARN"
  value       = aws_kinesis_firehose_delivery_stream.delivery_stream.arn
}

output "destination_role_arn" {
  description = "Role for CloudWatch Logs to assume when writing to Firehose"
  value       = aws_iam_role.destination.arn
}
