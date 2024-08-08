output "role" {
  description = "IAM role to be assummed by Observe"
  value       = aws_iam_role.this
}
