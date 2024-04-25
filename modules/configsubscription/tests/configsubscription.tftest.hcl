run "setup" {
  module {
    source = "../testing/setup"
  }

  variables {
    id_length = 50
  }
}

run "create_sqs" {
  module {
    source = "../testing/sqs_queue"
  }

  variables {
    setup = run.setup
  }
}

run "install" {
  variables {
    name_prefix = run.setup.short
    target_arn  = run.create_sqs.queue.arn
  }
}
