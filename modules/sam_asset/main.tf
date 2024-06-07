locals {
  # updatecli will bump this value when new releases become available
  latest_version = "1.19.3"

  release_version = var.release_version != "" ? var.release_version : local.latest_version
}

data "aws_region" "current" {}

data "http" "manifest" {
  url = "https://observeinc-${data.aws_region.current.name}.s3.amazonaws.com/aws-sam-apps/${local.release_version}/${var.asset}"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200 && can(yamldecode(self.response_body))
      error_message = "Unable to retrieve manifest"
    }
  }
}
