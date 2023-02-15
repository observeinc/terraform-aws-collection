# Basic terraform tests. If they break, you probably have introduced a breaking change.
# These tests cannot catch errors, but can be used to verify that the more complex variables worked as expected.

provider "aws" {}

module "test_defaults" {
  source                = "../"
  name                  = "${var.name}-defaults"
  log_subscription_name = "${var.name}-defaults-logs"
  observe_customer      = "123"
  observe_token         = "ds123456789:dogdogdogdog"
}

locals {
  result_defaults = {
    "cloudtrail" : length(module.test_defaults.cloudtrail) > 0,
  }
}

module "test_non_defaults" {
  source = "../"

  name                  = "${var.name}-non-defaults"
  log_subscription_name = "${var.name}-non-defaults-logs"
  observe_customer      = "123"
  observe_token         = "ds123456789:dogdogdogdog"

  lambda_version = "v1.0.20230210"
  lambda_s3_custom_rules = [{
    pattern = ".*"
    headers = {
      "my-http-header" : "my-http-value"
    }
  }]
  lambda_reserved_concurrent_executions = 10
  retention_in_days                     = 7
  lambda_envvars = {
    "MY_KEY" : "my-value"
  }
  # dead_letter_queue_destination = 
  # subscribed_s3_bucket_arns = 

  subscribed_log_group_matches  = [".*"]
  subscribed_log_group_excludes = [".*bean.*", ".*nginx.*"]

  tags = {
    "my-key" = "my-value"
  }

  # s3_exported_prefix =
  # s3_logging =
  # s3_lifecycle_rule = 

  snapshot_include             = ["cloudformation:List*"]
  snapshot_exclude             = ["kms:List*"]
  snapshot_schedule_expression = "rate(1 hour)"

  # kms_key_id = 

  # cloudtrail_is_multi_region_trail = 
  cloudtrail_enable = false
  # cloudtrail_enable_log_file_validation = 
  # cloudtrail_exclude_management_event_sources = 

  # cloudwatch_metrics_include_filters = 
  # cloudwatch_metrics_exclude_filters = 
}

locals {
  result_non_defaults = {
    "cloudtrail" : length(module.test_non_defaults.cloudtrail) == 0,
    # "tags_bucket" : module.test_module_2.bucket.tags == {"my-key" = "my-value"}
  }
}

# tflint-ignore: terraform_standard_module_structure
output "result" {
  description = "True of false"
  value = (
    alltrue([for k, v in local.result_defaults : v]) &&
    alltrue([for k, v in local.result_non_defaults : v])
  )
}

# tflint-ignore: terraform_standard_module_structure
output "result_details" {
  description = "A map of the test statuses"
  value = {
    result_defaults     = local.result_defaults
    result_non_defaults = local.result_non_defaults
  }
}
