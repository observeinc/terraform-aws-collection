locals {
  latest_release  = "1.19.3"
  release_version = var.release_version != "" ? var.release_version : local.latest_release
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
