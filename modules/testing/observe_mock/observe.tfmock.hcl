mock_data "observe_workspace" {
  defaults = {
    oid = "o:::workspace:41067315"
  }
}

mock_data "observe_ingest_info" {
  defaults = {
    collect_url = "https://123456789012.collect.observe-eng.com/"
    domain      = "observe-eng.com"
    scheme      = "https"
  }
}

mock_resource "observe_datastream" {
  defaults = {
    oid  = "o:::datastream:41567890"
  }
}

mock_resource "observe_datastream_token" {
  defaults = {
    datastream  = "o:::datastream:41567890"
    disabled   = false
    id         = "ds1vL16OMVWOwVjMeUac"
    name       = "stack-http"
    oid        = "o:::datastreamtoken:ds1vL16OMVWOwVjMeUac"
    secret     = "I-fJA2Fl0NVsiaJmn54PxG-35BGajprw"
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
