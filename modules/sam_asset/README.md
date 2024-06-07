# SAM Asset

This is a helper module to retrieve objects for a given release version from
https://github.com/observeinc/aws-sam-apps.

If no `release_version` is provided, we will default to a hard-coded value
which is maintained up to date by `updatecli`. This ensures that a given
terraform module release produces the same behavior across time.

## Usage

```hcl
module "sam_asset" {
    source          = "observeinc/collection/aws//modules/sam_asset"
    asset           = "forwarder.yaml"
    release_version = "1.19.3"
}
```
