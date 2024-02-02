run "setup" {
  module {
    source = "../testing/run"
  }
}

run "install_logwriter" {
  variables {
    name                    = run.setup.short
    bucket_arn              = run.setup.bucket_arn
    discovery_rate          = "10 minutes"
    filter_name             = "${run.setup.id}-filter"
    log_group_name_patterns = ["${run.setup.short}"]
  }
}