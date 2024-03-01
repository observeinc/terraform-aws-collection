locals {
  stack_name = substr("${random_pet.run.id}-${random_id.suffix.hex}", 0, 128)
  id         = substr(local.stack_name, 0, var.id_length)
  short      = substr(local.stack_name, 0, var.short_length)
}

resource "random_pet" "run" {
  length = 2
}

resource "random_id" "suffix" {
  byte_length = 64
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
