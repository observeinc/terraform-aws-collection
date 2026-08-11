# Mock response for sam_asset data "http" calls.
#
# response_body must be valid YAML that satisfies all SAM asset consumers:
#   - forwarder.yaml   → Resources.Forwarder.Properties.CodeUri
#   - logwriter.yaml   → Resources.Subscriber.Properties.CodeUri
#   - recommended.yaml → IncludeFilters / ExcludeFilters (only when no explicit filters are passed)
#
# status_code = 200 is required to satisfy the lifecycle postcondition in sam_asset.
mock_data "http" {
  defaults = {
    status_code = 200
    response_body = <<-YAML
      Resources:
        Forwarder:
          Properties:
            CodeUri: s3://mock-bucket/mock-key
        Subscriber:
          Properties:
            CodeUri: s3://mock-bucket/mock-key
      IncludeFilters: []
      ExcludeFilters: []
    YAML
  }
}
