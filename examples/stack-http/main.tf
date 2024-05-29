locals {
  name = basename(abspath(path.root))

  token               = nonsensitive(observe_datastream_token.this.secret)
  collection_endpoint = trim(data.observe_ingest_info.this.collect_url, "https://")
}

data "observe_workspace" "default" {
  name = "Default"
}

data "observe_ingest_info" "this" {}

resource "observe_datastream" "this" {
  workspace = data.observe_workspace.default.oid
  name      = local.name
}

resource "observe_datastream_token" "this" {
  datastream = observe_datastream.this.oid
  name       = local.name
}

module "stack" {
  # Prefer using the hashicorp registry:
  # source = "observeinc/collection/aws//modules/forwarder"
  # For validation purposes we will instead refer to a local version of the
  # module:
  source = "../..//modules/stack"

  name = local.name
  destination = {
    uri = "https://${local.token}@${local.collection_endpoint}/v1/http"
  }
}
