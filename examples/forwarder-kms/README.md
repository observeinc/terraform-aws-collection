# Forwarding KMS encrypted buckets

This module exemplifies how to forward objects from a KMS encrypted bucket. The
`forwarder` module must be configured with a list of `source_kms_key_arns`, and
the KMS key must have a policy that grants the lambda function permission to
decrypt objects.
