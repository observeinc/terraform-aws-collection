output "queue_arn" {
  description = "SQS Queue ARN. Events sent to this queue are delivered to the forwarder Lambda."
  value       = aws_sqs_queue.this.arn
}
