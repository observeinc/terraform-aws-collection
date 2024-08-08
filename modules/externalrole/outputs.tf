output "arn" {
  description = "ARN for IAM role to be assumed by Observe"
  value       = aws_iam_role.this.arn
}
