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

resource "aws_s3_bucket" "this" {
  bucket        = random_pet.run.id
  force_destroy = true
}

resource "aws_s3_access_point" "this" {
  bucket = aws_s3_bucket.this.id
  name   = random_pet.run.id
}
