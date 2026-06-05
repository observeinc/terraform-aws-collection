variable "test_run_id" {
  type        = string
  description = "Workflow run ID for CI (set via TF_VAR_test_run_id=github.run_id). Omit locally for a random suffix."
  default     = null
  nullable    = true
}
