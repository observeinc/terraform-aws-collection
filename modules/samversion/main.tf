locals {
  latest_release = "1.19.3"
  code_version   = var.release != "" ? var.release : local.latest_release
  code_uri       = yamldecode(data.http.manifest.response_body)["Resources"][var.function]["Properties"]["CodeUri"]
}

data "aws_region" "current" {}

data "http" "manifest" {
  url = "https://observeinc-${data.aws_region.current.name}.s3.amazonaws.com/aws-sam-apps/${local.code_version}/${var.app}.yaml"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200 && can(yamldecode(self.response_body))
      error_message = "Unable to retrieve manifest"
    }
  }
}
