run "setup" {
  module {
    source = "../testing/setup"
  }
}

run "install" {
  variables {
    name                   = run.setup.id
    observe_aws_account_id = "158067661102"
    datastream_ids         = ["4100001"]
    allowed_actions = [
      "cloudwatch:ListMetrics",
    ]
  }
}
