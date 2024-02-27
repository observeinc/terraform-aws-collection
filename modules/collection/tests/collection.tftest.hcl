run "setup" {
  module {
    source = "../testing/run"
  }

  variables {
    id_length = 50
  }
}

run "install" {
  variables {
    name = run.setup.id
    destination = {
      arn    = run.setup.access_point.arn
      bucket = run.setup.access_point.alias
      prefix = ""
    }

    config = {
      include_resource_types  = ["*"]
    }

    logwriter = {
      log_group_name_patterns = ["*"]
    }

    metricstream = {
      include_filters = [
        {
          namespace = "AWS/RDS"
        }
      ]
    }
  }
}
