# [2.8.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.7.0...v2.8.0) (2024-03-02)


### Bug Fixes

* bump lambda URIs ([#111](https://github.com/observeinc/terraform-aws-collection/issues/111)) ([7469a3a](https://github.com/observeinc/terraform-aws-collection/commit/7469a3a6241e126ca9a7524f4f025adb591e1a74))
* bump minimum terraform version to 1.2 ([#104](https://github.com/observeinc/terraform-aws-collection/issues/104)) ([9b578e4](https://github.com/observeinc/terraform-aws-collection/commit/9b578e4a0d4a9489f1643a03add4b0793c44bda8))
* **collection:** set default discovery rate to 24 hours ([#113](https://github.com/observeinc/terraform-aws-collection/issues/113)) ([f147552](https://github.com/observeinc/terraform-aws-collection/commit/f147552ce46b8798e54ca239091bd282a7294b40))
* **config:** add `include_resource_types` and `exclude_resource_types` ([#102](https://github.com/observeinc/terraform-aws-collection/issues/102)) ([68229fe](https://github.com/observeinc/terraform-aws-collection/commit/68229feae57502d9fd5c5852bc63adaef1dcfb3c))
* **forwarder:** output queue ARN ([f9f54af](https://github.com/observeinc/terraform-aws-collection/commit/f9f54afc139ad205ba46c4907ccb90bada7b03d6))
* **logwriter:** truncate name_prefix ([548bb8d](https://github.com/observeinc/terraform-aws-collection/commit/548bb8d151e2e1875ad85fe6b3235b9cc45da49a))
* remove cloudwatchlogs override ([#112](https://github.com/observeinc/terraform-aws-collection/issues/112)) ([b6d568d](https://github.com/observeinc/terraform-aws-collection/commit/b6d568d2e5cfb109076562d130b5792572d6163f))
* **subscriber:** adjust discovery_rate default and name_prefix ([7a3e38a](https://github.com/observeinc/terraform-aws-collection/commit/7a3e38af176d0d813707c73d43c1faf97df50285))


### Features

* add collection module ([#109](https://github.com/observeinc/terraform-aws-collection/issues/109)) ([a447145](https://github.com/observeinc/terraform-aws-collection/commit/a447145fdb1140146063e7b7511b79327e2f9e77))
* add metricstream module ([#110](https://github.com/observeinc/terraform-aws-collection/issues/110)) ([975394e](https://github.com/observeinc/terraform-aws-collection/commit/975394ee3e0be038c3f961f52e1b0813173ca714))
* **testing:** break up run module ([#115](https://github.com/observeinc/terraform-aws-collection/issues/115)) ([aa1948f](https://github.com/observeinc/terraform-aws-collection/commit/aa1948f0932cead0b719bc5c3912193f5eeea44e))
* **testing:** encrypt S3 bucket using KMS ([#114](https://github.com/observeinc/terraform-aws-collection/issues/114)) ([ac72097](https://github.com/observeinc/terraform-aws-collection/commit/ac720979b647a2ef6c031062a9a405465b88a88f))



