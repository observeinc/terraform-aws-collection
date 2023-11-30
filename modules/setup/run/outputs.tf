output "id" {
  description = "Random test identifier"
  value       = random_pet.run.id
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
