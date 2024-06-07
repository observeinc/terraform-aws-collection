# SAM Version

This is a helper module that given a SAM App name and Lambda function resource ID returns the code URI.

## Usage

```hcl
module "samversion" {
    app      = "forwarder"
    function = "Forwarder"
    release  = "1.19.3"
}
```

If `release` is omitted, we will default to a value that is updated by `updatecli`.
