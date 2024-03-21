run "setup" {
  module {
    source = "../testing/setup"
  }

  variables {
    id_length = 50
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

run "install" {
  variables {
    name = run.setup.id
    destination = {
      arn    = run.create_bucket.access_point.arn
      bucket = run.create_bucket.access_point.alias
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
