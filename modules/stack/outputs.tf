output "bucket" {
  description = "S3 bucket subscribed to forwarder"
  value       = aws_s3_bucket.this
}

output "config" {
  description = "Config module"
  value       = one(module.config)
}

output "configsubscription" {
  description = "ConfigSubscription module"
  value       = one(module.configsubscription)
}

output "forwarder" {
  description = "Forwarder module"
  value       = module.forwarder
}

output "logwriter" {
  description = "LogWriter module"
  value       = one(module.logwriter)
}

output "metricstream" {
  description = "MetricStream module"
  value       = one(module.metricstream)
}

output "topic" {
  description = "SNS topic subscribed to forwarder"
  value       = aws_sns_topic.this
}
