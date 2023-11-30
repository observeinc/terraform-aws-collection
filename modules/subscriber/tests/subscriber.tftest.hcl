run "setup" {
  module {
    source = "../setup/run"
  }
}

run "install" {
  variables {
    name = run.setup.id
    discovery_rate = "5 minutes"
  }
}

run "check_eventbridge_invoked" {
  module {
    source = "../exec"
  }

  variables {
    command = "./scripts/check_subscriber"
    env_vars = {
      FUNCTION_ARN = run.install.function.arn
    }
  }

  assert {
    condition     = output.error == ""
    error_message = "Failed to verify subscriber invocation"
  }
}
