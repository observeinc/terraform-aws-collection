output "error" {
  description = "Error message from process"
  value       = data.external.check.result.error
}

output "exitcode" {
  description = "Exit code for process"
  value       = tonumber(data.external.check.result.exitcode)
}

output "output" {
  description = "Process output"
  value       = data.external.check.result.output
}
