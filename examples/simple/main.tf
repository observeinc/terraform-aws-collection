module "observe_collection" {
  #source           = "github.com/observeinc/terraform-aws-collection"
  source           = "../../"
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_domain   = var.observe_domain
}