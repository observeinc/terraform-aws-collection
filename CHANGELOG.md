# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



<a name="v0.10.0"></a>
## [v0.10.0] - 2022-04-20

- feat: bump lambda to v0.13.0 ([#20](https://github.com/observeinc/terraform-aws-lambda/issues/20))
- fix: allow setting reserved_concurrent_executions ([#19](https://github.com/observeinc/terraform-aws-lambda/issues/19))
- ci: update pre-commit ([#21](https://github.com/observeinc/terraform-aws-lambda/issues/21))
- feat: allow filtering on cloudwatch metrics by namespace ([#18](https://github.com/observeinc/terraform-aws-lambda/issues/18))


<a name="v0.9.0"></a>
## [v0.9.0] - 2022-02-16

- chore: update CHANGELOG
- feat: update lambda module to v0.12.0 ([#17](https://github.com/observeinc/terraform-aws-lambda/issues/17))
- feat: bump terraform-aws-kinesis-firehose to v0.4.0 ([#16](https://github.com/observeinc/terraform-aws-lambda/issues/16))
- fix: pin AWS provider to v3.X ([#15](https://github.com/observeinc/terraform-aws-lambda/issues/15))


<a name="v0.8.0"></a>
## [v0.8.0] - 2022-01-31

- chore: update CHANGELOG
- feat: update lambda module to v0.11.0 ([#14](https://github.com/observeinc/terraform-aws-lambda/issues/14))
- feat: allow overriding snapshot schedule expression ([#13](https://github.com/observeinc/terraform-aws-lambda/issues/13))
- fix: remove action variable, allow falling back to default ([#12](https://github.com/observeinc/terraform-aws-lambda/issues/12))


<a name="v0.7.0"></a>
## [v0.7.0] - 2022-01-14

- chore: update CHANGELOG
- fix: update terraform-aws-lambda to v0.9.0 ([#11](https://github.com/observeinc/terraform-aws-lambda/issues/11))
- feat: add `cloudtrail_enable_log_validation` option ([#10](https://github.com/observeinc/terraform-aws-lambda/issues/10))


<a name="v0.6.0"></a>
## [v0.6.0] - 2022-01-03

- chore: update CHANGELOG
- chore: update pre-commit
- feat: add kms_key_id to cloudtrail ([#9](https://github.com/observeinc/terraform-aws-lambda/issues/9))


<a name="v0.5.0"></a>
## [v0.5.0] - 2021-11-29

- chore: update CHANGELOG.tpl.md
- feat: allow specifying additional s3 buckets ([#8](https://github.com/observeinc/terraform-aws-lambda/issues/8))
- Fix diagram indents


<a name="v0.4.0"></a>
## [v0.4.0] - 2021-11-17

- docs: update CHANGELOG
- fix: expand permissions to include s3:GetBucketTagging ([#6](https://github.com/observeinc/terraform-aws-lambda/issues/6))
- ci: pre-commit bump and conventional commit check ([#7](https://github.com/observeinc/terraform-aws-lambda/issues/7))
- ci: add github workflow ([#5](https://github.com/observeinc/terraform-aws-lambda/issues/5))


<a name="v0.3.0"></a>
## [v0.3.0] - 2021-09-23

- feat: extend default actions ([#4](https://github.com/observeinc/terraform-aws-lambda/issues/4))
- feat: allow overriding actions in snapshot module


<a name="v0.2.0"></a>
## [v0.2.0] - 2021-08-23

- feat: upgrade terraform-aws-lambda to 0.7.0


<a name="v0.1.0"></a>
## v0.1.0 - 2021-07-22

- s3: allow Redshift audit logs
- lambda: bump version, add lambda_s3_custom_rules var
- s3_bucket: introduce s3 bucket module
- Fix README source.
- First commit


[Unreleased]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.10.0...HEAD
[v0.10.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.9.0...v0.10.0
[v0.9.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.8.0...v0.9.0
[v0.8.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.7.0...v0.8.0
[v0.7.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.6.0...v0.7.0
[v0.6.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.5.0...v0.6.0
[v0.5.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/observeinc/terraform-aws-lambda/compare/v0.1.0...v0.2.0
