run "setup" {
  module { source = "../testing/setup" }
}

run "create_bucket" {
  module { source = "../testing/s3_bucket" }
  variables { setup = run.setup }
}

# Create test log groups to subscribe to
run "create_log_groups" {
  module { source = "../testing/exec" }
  variables {
    command = "aws"
    args    = ["logs", "create-log-group", "--log-group-name", "/test/${run.setup.short}/group-a"]
  }
}

# Apply with pattern matching group-a. The filter name is unique to this run so
# that subscribers from concurrent tests in the same account neither prune it
# nor are counted by the assertions below.
# Discovery scans every log group in the account, and concurrent tests doing the
# same throttle the CloudWatch Logs API, so a single batch can outlast the
# default 120s lambda_timeout.
run "install_subscriber" {
  module { source = "../../modules/logwriter" }
  variables {
    name                        = run.setup.short
    bucket_arn                  = run.create_bucket.arn
    filter_name                 = "${run.setup.id}-filter"
    log_group_name_patterns     = ["/test/${run.setup.short}"]
    wait_for_discovery_on_apply = true
    lambda_timeout              = 600
  }
}

# Verify subscription filter exists
run "check_filter_exists" {
  module { source = "../testing/exec" }
  variables {
    command = "aws"
    args    = ["logs", "describe-subscription-filters", "--log-group-name", "/test/${run.setup.short}/group-a", "--query", "length(subscriptionFilters[?filterName=='${run.setup.id}-filter'])", "--output", "text"]
  }
  assert {
    condition     = output.output == "1"
    error_message = "subscription filter should exist"
  }
}

# UPDATE: change pattern to something that doesn't match
run "update_subscriber" {
  module { source = "../../modules/logwriter" }
  variables {
    name                        = run.setup.short
    bucket_arn                  = run.create_bucket.arn
    filter_name                 = "${run.setup.id}-filter"
    log_group_name_patterns     = ["/test/${run.setup.short}/other"]
    wait_for_discovery_on_apply = true
    lambda_timeout              = 600
  }
}

# Verify old filter was removed (fullyPrune)
run "check_filter_removed" {
  module { source = "../testing/exec" }
  variables {
    command = "aws"
    args    = ["logs", "describe-subscription-filters", "--log-group-name", "/test/${run.setup.short}/group-a", "--query", "length(subscriptionFilters[?filterName=='${run.setup.id}-filter'])", "--output", "text"]
  }
  assert {
    condition     = output.output == "0"
    error_message = "subscription filter should have been pruned"
  }
}
