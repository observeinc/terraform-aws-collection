output "error" {
  description = "Error message"
  value       = data.external.check.result.error
}

output "exitcode" {
  description = "Exit code"
  value       = tonumber(data.external.check.result.exitcode)
}

output "output" {
  description = "Output"
  value       = data.external.check.result.output
}
