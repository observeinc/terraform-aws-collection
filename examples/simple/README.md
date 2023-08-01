## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.68 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_observe_collection"></a> [observe\_collection](#module\_observe\_collection) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_observe_customer"></a> [observe\_customer](#input\_observe\_customer) | Observe Customer ID | `string` | n/a | yes |
| <a name="input_observe_domain"></a> [observe\_domain](#input\_observe\_domain) | Observe domain | `string` | `null` | no |
| <a name="input_observe_token"></a> [observe\_token](#input\_observe\_token) | Observe token | `string` | n/a | yes |

## Outputs

No outputs.
