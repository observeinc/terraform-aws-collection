output "bucket" {
  description = "S3 bucket subscribed to Observe Lambda"
  value       = module.observe_collection.bucket
}

output "observe_lambda" {
  description = "Observe Lambda module"
  value       = module.observe_collection.observe_lambda
}
