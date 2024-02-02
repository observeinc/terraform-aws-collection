run "setup" {
  module {
    source = "../testing/run"
  }

  variables {
    id_length = 52
  }
}

run "install_full" {
  variables {
    name = run.setup.id
    destination = {
      arn    = run.setup.access_point.arn
      bucket = run.setup.access_point.alias
      prefix = ""
    }
    include_resource_types  = ["*"]
    log_group_name_patterns = ["*"]
  }
}
