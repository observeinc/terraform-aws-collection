output "stack_name" {
  description = "Random test identifier padded out to 128 characters."
  value       = local.stack_name
}

output "id" {
  description = "Run identifier"
  value       = local.id
}

output "short" {
  description = "Identifier truncated to a shorter length."
  value       = local.short
}

output "region" {
  description = "AWS Region in use"
  value       = data.aws_region.current.name
}

output "account_id" {
  description = "AWS Account in use"
  value       = data.aws_caller_identity.current.account_id
}

output "access_point" {
  description = "S3 access point where files are copied to"
  value       = aws_s3_access_point.this
}
