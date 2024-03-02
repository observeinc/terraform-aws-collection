run "setup" {
  module {
    source = "../testing/setup"
  }
}

run "create_bucket" {
  module {
    source = "../testing/s3_bucket"
  }

  variables {
    setup = run.setup
  }
}

run "install_logwriter" {
  variables {
    name                    = run.setup.short
    bucket_arn              = run.create_bucket.arn
    discovery_rate          = "10 minutes"
    filter_name             = "${run.setup.id}-filter"
    log_group_name_patterns = ["${run.setup.short}"]
  }
}
