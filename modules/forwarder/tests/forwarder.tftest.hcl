variables {
  override_match        = "example"
  override_content_type = "application/x-csv;delimiter=space"
}

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

run "install_forwarder" {
  variables {
    name = run.setup.id
    destination = {
      arn    = ""
      bucket = run.create_bucket.id
      prefix = ""
    }
    source_bucket_names = [for source in ["sns", "sqs", "eventbridge"] : "${run.setup.short}-${source}"]
    source_topic_arns   = ["arn:aws:sns:${run.setup.region}:${run.setup.account_id}:*"]
    content_type_overrides = [
      {
        pattern      = var.override_match
        content_type = var.override_content_type
      }
    ]
  }
}
