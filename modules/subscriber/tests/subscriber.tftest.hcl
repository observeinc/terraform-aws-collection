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

# Apply with pattern matching group-a
run "install_subscriber" {
  module { source = "../../modules/logwriter" }
  variables {
    name                    = run.setup.short
    bucket_arn              = run.create_bucket.arn
    log_group_name_patterns = ["/test/${run.setup.short}"]
  }
}

# Verify subscription filter exists
run "check_filter_exists" {
  module { source = "../testing/exec" }
  variables {
    command = "aws"
    args    = ["logs", "describe-subscription-filters", "--log-group-name", "/test/${run.setup.short}/group-a", "--query", "subscriptionFilters[0].filterName", "--output", "text"]
  }
  assert {
    condition     = output.output != ""
    error_message = "subscription filter should exist"
  }
}

# UPDATE: change pattern to something that doesn't match
run "update_subscriber" {
  module { source = "../../modules/logwriter" }
  variables {
    name                    = run.setup.short
    bucket_arn              = run.create_bucket.arn
    log_group_name_patterns = ["/test/${run.setup.short}/other"]
  }
}

# Verify old filter was removed (fullyPrune)
run "check_filter_removed" {
  module { source = "../testing/exec" }
  variables {
    command = "aws"
    args    = ["logs", "describe-subscription-filters", "--log-group-name", "/test/${run.setup.short}/group-a", "--query", "length(subscriptionFilters)", "--output", "text"]
  }
  assert {
    condition     = output.output == "0"
    error_message = "subscription filter should have been pruned"
  }
}