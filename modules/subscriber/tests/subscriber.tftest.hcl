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

run "install_logwriter_no_discovery" {
  module {
    source = "../../modules/logwriter"
  }

  variables {
    name                    = run.setup.short
    bucket_arn              = run.create_bucket.arn
    filter_name             = "${run.setup.id}-filter"
    log_group_name_patterns = ["${run.setup.short}"]
  }

  assert {
    condition     = output.subscriber != null
    error_message = "subscriber should be created when patterns are set"
  }
}
