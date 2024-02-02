output "subscriber" {
  description = "Subscriber module"
  value       = one(module.subscriber)
}

output "firehose" {
  description = "Kinesis Firehose Delivery Stream ARN"
  value       = aws_kinesis_firehose_delivery_stream.delivery_stream.arn
}

output "destination_iam_policy" {
  description = "Firehose destination iam policy"
  value       = aws_iam_role.destination.arn
}