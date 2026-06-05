resource "random_string" "run" {
  length  = 8
  special = false
  upper   = false
}

locals {
  example    = basename(abspath(path.root))
  run_suffix = coalesce(var.test_run_id, random_string.run.result)
  name       = "tac-${local.run_suffix}-${local.example}"

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
  source = "../..//modules/forwarder"

  name = local.name
  destination = {
    uri = "https://${local.token}@${local.collection_endpoint}/v1/http"
  }
}
