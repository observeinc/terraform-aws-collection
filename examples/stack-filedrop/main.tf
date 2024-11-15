locals {
  name = basename(abspath(path.root))
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "observe_workspace" "default" {
  name = "Default"
}

resource "observe_datastream" "this" {
  workspace = data.observe_workspace.default.oid
  name      = local.name
}

resource "observe_filedrop" "this" {
  workspace  = data.observe_workspace.default.oid
  datastream = observe_datastream.this.oid

  config {
    provider {
      aws {
        region   = "us-west-2"
        role_arn = "arn:${data.aws_partition.current.id}:iam::${data.aws_caller_identity.current.account_id}:role/${local.name}"
      }
    }
  }
}

module "stack" {
  # Prefer using the hashicorp registry:
  # source = "observeinc/collection/aws//modules/forwarder"
  # For validation purposes we will instead refer to a local version of the
  # module:
  source = "../..//modules/stack"

  name        = local.name
  destination = observe_filedrop.this.endpoint[0].s3[0]
}
