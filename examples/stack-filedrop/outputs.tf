output "log_group" {
  description = "Forwarder Lambda log group"
  value       = module.stack.log_group
}

output "queue_arn" {
  description = "SQS Queue ARN for the forwarder"
  value       = module.stack.queue_arn
}
