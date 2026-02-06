variable "name" {
  description = "Trail name. Also used as bucket prefix"
  type        = string
  nullable    = false
}

variable "s3_key_prefix" {
  description = "Optional prefix to write CloudTrail records to."
  type        = string
  nullable    = false
  default     = ""
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in the current region or in all regions"
  type        = bool
  default     = false
  nullable    = false
}

variable "exclude_management_event_sources" {
  description = <<-EOF
    A list of management event sources to exclude from CloudTrail.
    To capture all CloudTrail management events, leave this as an empty list ([]).
  EOF
  type        = list(string)
  default     = ["kms.amazonaws.com", "rdsdata.amazonaws.com"]
  nullable    = true
}

variable "tags" {
  description = "Tags to add to the resources."
  type        = map(string)
  default     = {}
}