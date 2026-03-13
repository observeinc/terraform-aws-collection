# SAM Asset

This is a helper module to retrieve objects for a given release version from
https://github.com/observeinc/aws-sam-apps.

If no `release_version` is provided, we will default to a hard-coded value
which is maintained up to date by `updatecli`. This ensures that a given
terraform module release produces the same behavior across time.

## Outbound network dependency

During `terraform plan` and `terraform apply`, this module makes an HTTPS request to an Observe-managed S3 bucket to fetch a SAM manifest:

```
https://observeinc-<region>.s3.amazonaws.com/aws-sam-apps/<version>/<asset>
```

Where `<region>` is the current AWS region. This means:

- The machine running Terraform must have outbound HTTPS access to `observeinc-<region>.s3.amazonaws.com`.
- Environments with restricted egress (VPC-only, proxy-gated, or air-gapped networks) must allowlist this endpoint.
- Artifact buckets are only maintained for **AWS Global regions**. AWS China and GovCloud regions are not supported and will fail with an HTTP error.

If outbound access is not possible, you can pre-download the asset and provide the Lambda binary location directly via the `code_uri` variable on the consuming module (e.g., `forwarder`, `logwriter`), which bypasses this module entirely.

## Usage

```hcl
module "sam_asset" {
    source          = "observeinc/collection/aws//modules/sam_asset"
    asset           = "forwarder.yaml"
    release_version = "1.19.3"
}
```
