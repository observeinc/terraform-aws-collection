variable "command" {
  description = <<-EOF
    Command to execute
  EOF
  type        = string
  nullable    = false
}

variable "args" {
  description = <<-EOF
    Command line arguments
  EOF
  type        = list(string)
  nullable    = false
  default     = []
}

variable "env_vars" {
  description = <<-EOF
    Environment variables
  EOF
  type        = map(string)
  default     = {}
  nullable    = false
}
