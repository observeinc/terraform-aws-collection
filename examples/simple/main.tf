resource "random_pet" "run" {}

module "observe_collection" {
  #source           = "github.com/observeinc/terraform-aws-collection"
  source           = "../../"
  name             = random_pet.run.id
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_domain   = var.observe_domain
}
