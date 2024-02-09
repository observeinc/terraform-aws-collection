output "queue_arn" {
  description = "SQS Queue ARN"
  value       = aws_sqs_queue.this.arn
}
