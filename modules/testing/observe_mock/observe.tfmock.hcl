mock_data "observe_workspace" {
  defaults = {
    oid = "o:::workspace:41067315"
  }
}

mock_resource "observe_datastream" {
  defaults = {
    oid  = "o:::datastream:41567890"
  }
}

mock_resource "observe_filedrop" {
  defaults = {
    id         = "41000000"
    name       = "filedrop-ds1pUUtmcrPETeLAwJeR"
    oid        = "o:::filedrop:41567892"
    status     = "running"
    endpoint = [
      {
        s3 = [
          {
            arn    = "arn:aws:s3:us-west-2:123456789012:accesspoint/000000000000"
            bucket = "000000000000-s1n88tucur4944c6p3ymbu6hr758gusw2a-s3alias"
            prefix = "ds1pUUtmcrPETeLAwJeR/"
          },
        ]
      },
    ]
  }
}
