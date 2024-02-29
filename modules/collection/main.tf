locals {
  name_prefix = "${substr(var.name, 0, 36)}-"

  content_type_overrides = concat(
    # placeholder for future overrides
    [
    ]
  , var.forwarder.content_type_overrides)

}
