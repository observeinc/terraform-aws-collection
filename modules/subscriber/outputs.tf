output "function" {
  description = "Function"
  value = {
    arn = aws_lambda_function.this.arn
  }
}

output "log_group_name" {
  description = "Log group name for Lambda function"
  value       = aws_cloudwatch_log_group.this.name
}

