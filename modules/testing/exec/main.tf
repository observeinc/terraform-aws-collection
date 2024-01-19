data "external" "check" {
  program = concat(["${path.module}/exec"], [var.command], var.args)
  query   = var.env_vars
}
