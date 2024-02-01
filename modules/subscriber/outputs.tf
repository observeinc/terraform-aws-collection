output "function_arn" {
  description = "Lambda Function ARN"
  value       = aws_lambda_function.subscriber.arn
}