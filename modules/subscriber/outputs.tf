output "function_arn" {
  description = "Lambda Function ARN"
  value       = aws_lambda_function.subscriber.arn
}

output "log_group" {
  description = "Lambda log group"
  value       = aws_cloudwatch_log_group.log_group
}
