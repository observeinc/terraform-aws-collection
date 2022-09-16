# [1.0.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.10.0...v1.0.0) (2022-09-16)


* fix!: remove deprecated variables (#26) ([cbff3eb](https://github.com/observeinc/terraform-aws-collection/commit/cbff3ebbdd2b3128ad862eb31e7d2da043976096)), closes [#26](https://github.com/observeinc/terraform-aws-collection/issues/26)
* feat!: bump lambda, kinesis-firehose modules (#25) ([5cd4c80](https://github.com/observeinc/terraform-aws-collection/commit/5cd4c8069b8c81a19f76fc1f67d9364d0ea27f22)), closes [#25](https://github.com/observeinc/terraform-aws-collection/issues/25)


### Features

* add variable for disabling cloudtrail ([#23](https://github.com/observeinc/terraform-aws-collection/issues/23)) ([e1a1341](https://github.com/observeinc/terraform-aws-collection/commit/e1a1341d0372199fdf184d78e22c14634082bbfd))
* bump observeinc/lambda/aws to 1.1.0 ([#27](https://github.com/observeinc/terraform-aws-collection/issues/27)) ([bcdfe10](https://github.com/observeinc/terraform-aws-collection/commit/bcdfe1005f01acc666559b4c69056a0d4e8f2192))
* use new log group subscription module ([#22](https://github.com/observeinc/terraform-aws-collection/issues/22)) ([46980bd](https://github.com/observeinc/terraform-aws-collection/commit/46980bd504460e2dcac1509ab4b3174ecfcf7347))


### BREAKING CHANGES

* `subscribed_log_group_names`, `cloudwatch_logs_subscribe_to_lambda` and
`cloudwatch_logs_subscribe_to_lambda` are no longer available as input
variables. Use `subscribed_log_group_matches` and
`subscribed_log_group_excludes` instead
* `observe_token` must now be in
`{datastream_token_id}:{datastream_token_secret}` format.



