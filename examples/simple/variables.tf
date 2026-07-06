variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe token"
  type        = string
}

variable "observe_domain" {
  description = "Observe domain"
  type        = string
  default     = null
}

variable "test_run_id" {
  description = "CI run ID used to tag resources for orphan detection and cleanup."
  type        = string
  default     = "local"
}