variables {
  override_match        = "example"
  override_content_type = "application/x-csv;delimiter=space"
}

run "setup" {
  module {
    source = "../testing/run"
  }
}

run "install_forwarder" {
  variables {
    name = run.setup.id
    destination = {
      arn    = run.setup.access_point.arn
      bucket = run.setup.access_point.alias
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
