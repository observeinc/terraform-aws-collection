output "log_group" {
  description = "Lambda log group."
  value       = aws_cloudwatch_log_group.this
}

output "queue_arn" {
  description = "SQS Queue ARN. Events sent to this queue are delivered to the forwarder Lambda."
  value       = aws_sqs_queue.this.arn
}
