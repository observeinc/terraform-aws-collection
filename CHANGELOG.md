## [2.32.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.32.0...v2.32.1) (2026-03-31)


### Bug Fixes

* align subscriber module with aws-sam-apps for correctness ([4de15f8](https://github.com/observeinc/terraform-aws-collection/commit/4de15f8bc6b61b810a688e875c29f3c84212298e))
* remove misplaced Terraform min/max version steps from permission_check job ([35276f5](https://github.com/observeinc/terraform-aws-collection/commit/35276f52c7762151e54418bd3eaae73ca2975424))



# [2.32.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.31.0...v2.32.0) (2026-03-17)


### Features

* Update dependencies ([4a17458](https://github.com/observeinc/terraform-aws-collection/commit/4a17458650fe218e575df3fcbda13b49517c7792))



# [2.31.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.30.0...v2.31.0) (2026-02-27)


### Features

* Update dependencies ([82dfdaa](https://github.com/observeinc/terraform-aws-collection/commit/82dfdaaf53fe169a47556690ee86c4ecf324e72d))



# [2.30.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.29.0...v2.30.0) (2026-02-24)


### Features

* Update Observe Lambda version to 3.8.0 ([aa18a3f](https://github.com/observeinc/terraform-aws-collection/commit/aa18a3f9b0ec82b89007cf9a213d6a09b417eb19))



# [2.29.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.28.1...v2.29.0) (2025-11-21)


### Features

* Add vpc_config ([4af2b10](https://github.com/observeinc/terraform-aws-collection/commit/4af2b1012ddcda4032eed6498b8084eea2044d02))
* Added org_id and source_accounts to allow SNS topic to receive AWS Config events from sub-accounts ([0088681](https://github.com/observeinc/terraform-aws-collection/commit/008868178b02d0beafb1ddab8d282ee0325f32f9))



## [2.28.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.28.0...v2.28.1) (2025-11-19)


### Bug Fixes

* Add cloudtrail_exclude_all_management_event_sources to exclude all events when CloudTrail is previously enabled.  OB-51116 ([abed268](https://github.com/observeinc/terraform-aws-collection/commit/abed268c4b15e0b1af698ed1db6c2d2ffbf0cea8))



# [2.28.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.27.0...v2.28.0) (2025-08-25)


### Features

* Clarify how to update cloudtrail_exclude_management_event_sources when cloudtrail_enable is false but CloudTrail is already enabled in the AWS Account (IN-522). Updated default to exclude all CloudTrail events. ([4d969f7](https://github.com/observeinc/terraform-aws-collection/commit/4d969f797100c428087b2c801cb0ed4d53bd8226))
* Update cloudwatch-logs-subscription to v0.6.0 ([a90cdd7](https://github.com/observeinc/terraform-aws-collection/commit/a90cdd7153e408b2264c08492d31ff2d146ae26d))



# [2.27.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.26.0...v2.27.0) (2025-07-02)


### Features

* Add filter and prefix to S3 aws_s3_bucket_lifecycle_configuration ([81db031](https://github.com/observeinc/terraform-aws-collection/commit/81db031d763728d7d6c9e19a466dedb89db52d8a))
* Explicitly set block_public_policy to true ([f68cc3e](https://github.com/observeinc/terraform-aws-collection/commit/f68cc3e6a978889aadab3738e60fbc488779f931))
* parameterize runtime and default to al2023 ([#194](https://github.com/observeinc/terraform-aws-collection/issues/194)) ([8a00036](https://github.com/observeinc/terraform-aws-collection/commit/8a0003677b4c3519a3f776fbfed5b71136384ce1))
* update dependencies ([f52e551](https://github.com/observeinc/terraform-aws-collection/commit/f52e551f38792a5baf016ade17eaf30267266636))
* update dependencies ([2e350ff](https://github.com/observeinc/terraform-aws-collection/commit/2e350ffa1994cf7d3e2cd0d641198dbe787a9049))



# [2.26.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.25.0...v2.26.0) (2024-11-18)


### Bug Fixes

* bump sam-assets to 2.3.2 ([#193](https://github.com/observeinc/terraform-aws-collection/issues/193)) ([a526b37](https://github.com/observeinc/terraform-aws-collection/commit/a526b3767f7be73a0f14e03af00769610f280ca9))


### Features

* bump sam assets to 2.3.1  ([#190](https://github.com/observeinc/terraform-aws-collection/issues/190)) ([56915ea](https://github.com/observeinc/terraform-aws-collection/commit/56915ea2e39e6088320ecdaa5d230a748d93c534))
* update dependencies ([ed79cbd](https://github.com/observeinc/terraform-aws-collection/commit/ed79cbd8bea678d589306d9142aad4e4dd136e7a))
* Update to use aws_partition for AWS China (aws-cn) compatibility ([c3cdfee](https://github.com/observeinc/terraform-aws-collection/commit/c3cdfeeb9d504e185dacddd9377775203435b83d))



# [2.25.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.24.0...v2.25.0) (2024-08-08)


### Bug Fixes

* **externalrole:** adjust outputs. ([#186](https://github.com/observeinc/terraform-aws-collection/issues/186)) ([85696a7](https://github.com/observeinc/terraform-aws-collection/commit/85696a7f97e8cbf3d4f1588dc306c39b9da8117f))


### Features

* add externalrole module ([#184](https://github.com/observeinc/terraform-aws-collection/issues/184)) ([65b2982](https://github.com/observeinc/terraform-aws-collection/commit/65b29824965de1b1c517362e0af3273b187b323f))
* update dependencies ([d1b7c42](https://github.com/observeinc/terraform-aws-collection/commit/d1b7c424b1d5560309372aae1169d3d52bb5187a))



# [2.24.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.23.0...v2.24.0) (2024-07-26)


### Bug Fixes

* adjust provider source for examples ([#182](https://github.com/observeinc/terraform-aws-collection/issues/182)) ([3d2cbbb](https://github.com/observeinc/terraform-aws-collection/commit/3d2cbbba1580584131d7447bc5f753e7c50007c3))
* **forwarder:** validate destination bucket name ([#181](https://github.com/observeinc/terraform-aws-collection/issues/181)) ([06347e7](https://github.com/observeinc/terraform-aws-collection/commit/06347e7c4f2a58abf8e2ac33cb5d1f43a7f1daa3))


### Features

* add cloudtrail module ([#180](https://github.com/observeinc/terraform-aws-collection/issues/180)) ([84d1c90](https://github.com/observeinc/terraform-aws-collection/commit/84d1c901ced989e2437a2e12128ec65444b6b93c))



# [2.23.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.22.0...v2.23.0) (2024-07-16)


### Bug Fixes

* **subscriber:** replace scheduler on variable changes ([#178](https://github.com/observeinc/terraform-aws-collection/issues/178)) ([38c44d7](https://github.com/observeinc/terraform-aws-collection/commit/38c44d757288e4e36da24d0b3db65f85c3777539))


### Features

* bump SAM apps version to 2.1.0 ([#179](https://github.com/observeinc/terraform-aws-collection/issues/179)) ([56126f5](https://github.com/observeinc/terraform-aws-collection/commit/56126f51910f2c58109d8c6c0956d1a09a12c0c7))



# [2.22.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.21.0...v2.22.0) (2024-07-08)


### Features

* set account alias as tag ([#159](https://github.com/observeinc/terraform-aws-collection/issues/159)) ([c2b5f0b](https://github.com/observeinc/terraform-aws-collection/commit/c2b5f0bf93d27a94835d1a02f6c20d00b5c1df71))



# [2.21.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.20.0...v2.21.0) (2024-06-18)


### Bug Fixes

* **forwarder:** filter eventbridge triggers by source bucket ([#175](https://github.com/observeinc/terraform-aws-collection/issues/175)) ([d4d0197](https://github.com/observeinc/terraform-aws-collection/commit/d4d01972f9b6e8441699519932eea89009973f42))


### Features

* **forwarder:** add `source_object_keys` parameter ([#176](https://github.com/observeinc/terraform-aws-collection/issues/176)) ([f1ad080](https://github.com/observeinc/terraform-aws-collection/commit/f1ad0804f0a986ce5b6df5b5d649d4bdb9811102))
* update sam release to 2.0.0 ([#177](https://github.com/observeinc/terraform-aws-collection/issues/177)) ([0cb909a](https://github.com/observeinc/terraform-aws-collection/commit/0cb909acef20e7ace60dd55fc79dc36a840885b2))



# [2.20.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.19.0...v2.20.0) (2024-06-13)


### Bug Fixes

* **logwriter:** subscribe on log group creation ([#172](https://github.com/observeinc/terraform-aws-collection/issues/172)) ([be62a49](https://github.com/observeinc/terraform-aws-collection/commit/be62a491b261ce5cf15a9877e55e31fe06c84979))


### Features

* bump lambda to 1.19.5 ([fec2174](https://github.com/observeinc/terraform-aws-collection/commit/fec2174b0604eded4744138bcf6247dfd495383a))
* update sam release to 1.19.6 ([7483894](https://github.com/observeinc/terraform-aws-collection/commit/748389490d8bb6a82bc3c6451f9d94744696f6fb))



# [2.19.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.18.0...v2.19.0) (2024-06-07)


### Bug Fixes

* **forwarder:** improve variable checks ([#165](https://github.com/observeinc/terraform-aws-collection/issues/165)) ([6352d13](https://github.com/observeinc/terraform-aws-collection/commit/6352d13de571edba6f770561c6e46ba05101551e))
* **logwriter:** remove default prefix ([#167](https://github.com/observeinc/terraform-aws-collection/issues/167)) ([99253b7](https://github.com/observeinc/terraform-aws-collection/commit/99253b7aab78ca7fba2f3e15845f86e6ccd4cb38))
* **metricstream:** lookup recommended filters ([#169](https://github.com/observeinc/terraform-aws-collection/issues/169)) ([8b7c1ce](https://github.com/observeinc/terraform-aws-collection/commit/8b7c1ce274c1174b4ab8ca16d58fa5d4d7511c2f))
* rename `code_version` to `sam_release_version` ([#166](https://github.com/observeinc/terraform-aws-collection/issues/166)) ([42a682e](https://github.com/observeinc/terraform-aws-collection/commit/42a682e33c887eb87f17e9f125d21885fec1b64b))


### Features

* bump SAM release to 1.19.4 ([#170](https://github.com/observeinc/terraform-aws-collection/issues/170)) ([e75c71a](https://github.com/observeinc/terraform-aws-collection/commit/e75c71a6c9cb829327c7a4c5a0ece66b9d771987))



# [2.18.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.17.2...v2.18.0) (2024-06-06)


### Features

* add helper module to determine `code_uri` ([#164](https://github.com/observeinc/terraform-aws-collection/issues/164)) ([c5c11f9](https://github.com/observeinc/terraform-aws-collection/commit/c5c11f9964044e0fc403785cdc646903a8be4960))
* update dependencies ([e8267f3](https://github.com/observeinc/terraform-aws-collection/commit/e8267f38fb51ddb04c710eccb2fb1a3dae8de04f))



## [2.17.2](https://github.com/observeinc/terraform-aws-collection/compare/v2.17.1...v2.17.2) (2024-05-30)


### Bug Fixes

* add binary uris ([6ddc3a3](https://github.com/observeinc/terraform-aws-collection/commit/6ddc3a3475d85b4baa99360b790c1d710ae55bb2))



## [2.17.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.17.0...v2.17.1) (2024-05-30)


### Bug Fixes

* **forwarder:** relax IAM role naming ([#160](https://github.com/observeinc/terraform-aws-collection/issues/160)) ([dd8347d](https://github.com/observeinc/terraform-aws-collection/commit/dd8347dffa3056ee99f3d314a546d54a18faa25d))
* **forwarder:** strip leading whitespace in eventbridge rule ([#161](https://github.com/observeinc/terraform-aws-collection/issues/161)) ([c8fe626](https://github.com/observeinc/terraform-aws-collection/commit/c8fe626df5f40a6c7ae549ac7658e0b5ebf3914e))
* update lambda functions to 1.19.1 ([#162](https://github.com/observeinc/terraform-aws-collection/issues/162)) ([204f5fb](https://github.com/observeinc/terraform-aws-collection/commit/204f5fb8e22565ac43288e84c7f4a2ad506df021))



# [2.17.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.16.0...v2.17.0) (2024-05-29)


### Bug Fixes

* **forwarder:** add SNS subscription example ([#155](https://github.com/observeinc/terraform-aws-collection/issues/155)) ([d82d874](https://github.com/observeinc/terraform-aws-collection/commit/d82d874604af80eded69f25a2b2a914461142faa))
* **forwarder:** update KMS example ([#156](https://github.com/observeinc/terraform-aws-collection/issues/156)) ([7badd76](https://github.com/observeinc/terraform-aws-collection/commit/7badd763263d078d317a903afe411e7d1d803dbd))
* **logwriter:** add examples ([#154](https://github.com/observeinc/terraform-aws-collection/issues/154)) ([0bd94fb](https://github.com/observeinc/terraform-aws-collection/commit/0bd94fbdd4f36adbf5391c2d6f0d383e7c0510f8))
* **stack:** add outputs ([#153](https://github.com/observeinc/terraform-aws-collection/issues/153)) ([81ff691](https://github.com/observeinc/terraform-aws-collection/commit/81ff691f0409b53a9b4b52fb806bddbb88d4a2d0))
* **stack:** update docs, examples ([#158](https://github.com/observeinc/terraform-aws-collection/issues/158)) ([1aeddc6](https://github.com/observeinc/terraform-aws-collection/commit/1aeddc65a1dfae33b32cb421f31363373dd4b3ce))


### Features

* update lambda functions to 1.19.0 ([1ed4197](https://github.com/observeinc/terraform-aws-collection/commit/1ed4197f612920f22b3eb626c35e51a243b0ae9c))



# [2.16.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.15.0...v2.16.0) (2024-05-22)


### Bug Fixes

* expose verbosity parameter ([#150](https://github.com/observeinc/terraform-aws-collection/issues/150)) ([c104ef7](https://github.com/observeinc/terraform-aws-collection/commit/c104ef75bd821b48aeddb978f8254d369c801eba))
* **forwarder:** adjust defaults based on URI ([#146](https://github.com/observeinc/terraform-aws-collection/issues/146)) ([9a97f76](https://github.com/observeinc/terraform-aws-collection/commit/9a97f76aea4d46ae3e8ab239b342980383e263c5))
* **metricstream:** set recommended filter by omission ([#151](https://github.com/observeinc/terraform-aws-collection/issues/151)) ([275f7bb](https://github.com/observeinc/terraform-aws-collection/commit/275f7bb158a3da25a130969058322df9359feb7c))
* **stack:** adjust default S3 expiration ([#148](https://github.com/observeinc/terraform-aws-collection/issues/148)) ([7b418df](https://github.com/observeinc/terraform-aws-collection/commit/7b418dfb2858dd5c3d79fa6110de65b909c0be99))


### Features

* **forwarder:** relax filedrop requirement ([#144](https://github.com/observeinc/terraform-aws-collection/issues/144)) ([e12656a](https://github.com/observeinc/terraform-aws-collection/commit/e12656a926c530969ba0df9b45dc20f0343e129a))
* **subscriber:** support log group exclusion ([#149](https://github.com/observeinc/terraform-aws-collection/issues/149)) ([b574556](https://github.com/observeinc/terraform-aws-collection/commit/b574556229080a07eaab028dfcaa1961259c1744))
* update dependencies ([#145](https://github.com/observeinc/terraform-aws-collection/issues/145)) ([18eb7c9](https://github.com/observeinc/terraform-aws-collection/commit/18eb7c923dc01044d241fa753c48be550ce923f0))
* update lambda binaries to 1.18.1 ([#147](https://github.com/observeinc/terraform-aws-collection/issues/147)) ([bcea400](https://github.com/observeinc/terraform-aws-collection/commit/bcea4004a130811dc8bf03556f3c6e91d22a52a3))



# [2.15.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.14.0...v2.15.0) (2024-05-01)


### Features

* bump lambda version to 3.6.0 ([#143](https://github.com/observeinc/terraform-aws-collection/issues/143)) ([d541cbd](https://github.com/observeinc/terraform-aws-collection/commit/d541cbd2c3b3d484414e15729ef0e91a7d39a088))
* **stack:** bump lambda version to 1.14.0 ([35d5677](https://github.com/observeinc/terraform-aws-collection/commit/35d5677581df8acbf5b19caf45c86fb4bde4d30e))



# [2.14.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.13.0...v2.14.0) (2024-04-26)


### Bug Fixes

* **configsubscription:** match targets, relax permissions ([#141](https://github.com/observeinc/terraform-aws-collection/issues/141)) ([73a16ab](https://github.com/observeinc/terraform-aws-collection/commit/73a16abb32d3944fd42af88a779ea652d5a2ec2a))
* **stack:** introduce configsubscription variable ([#140](https://github.com/observeinc/terraform-aws-collection/issues/140)) ([4906a0f](https://github.com/observeinc/terraform-aws-collection/commit/4906a0fc774ace043dcad791a4bf4c17a3a6caea))


### Features

* **stack:** add config subscription module ([#139](https://github.com/observeinc/terraform-aws-collection/issues/139)) ([828a811](https://github.com/observeinc/terraform-aws-collection/commit/828a811946add026dc2f09161584d617994603c2))



# [2.13.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.12.0...v2.13.0) (2024-04-22)


### Features

* bump lambda to 1.13.0 ([69d150b](https://github.com/observeinc/terraform-aws-collection/commit/69d150b945390d8308a1cde847d17c5b5bef1ff6))



# [2.12.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.11.1...v2.12.0) (2024-04-22)


### Bug Fixes

* **forwarder:** increase timeout ([#137](https://github.com/observeinc/terraform-aws-collection/issues/137)) ([f504492](https://github.com/observeinc/terraform-aws-collection/commit/f504492b76b7fbad8a42f4352e8ba5eb09704975))


### Features

* **forwarder:** add `debug_endpoint` parameter ([#136](https://github.com/observeinc/terraform-aws-collection/issues/136)) ([426ab11](https://github.com/observeinc/terraform-aws-collection/commit/426ab11a85ed0736cf79244226b14616736e2cea))
* update dependencies ([#133](https://github.com/observeinc/terraform-aws-collection/issues/133)) ([777722c](https://github.com/observeinc/terraform-aws-collection/commit/777722c4a70585c48e79b81ff1f613ba194238ac))



## [2.11.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.11.0...v2.11.1) (2024-04-11)


### Bug Fixes

* CS-425 update default aws snapshot lambda to 2gb and timeout 120s ([5a74516](https://github.com/observeinc/terraform-aws-collection/commit/5a74516543bfee023d52a72653c85f8e46503e9d))



# [2.11.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.10.0...v2.11.0) (2024-03-22)


### Features

* allow subscribing S3 bucket notifications to eventbridge ([#132](https://github.com/observeinc/terraform-aws-collection/issues/132)) ([5371b87](https://github.com/observeinc/terraform-aws-collection/commit/5371b877038f1ac3c509afa621d528b9966a5751))



# [2.10.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.9.0...v2.10.0) (2024-03-21)


### Bug Fixes

* **forwarder:** relax access point arn requirement ([#120](https://github.com/observeinc/terraform-aws-collection/issues/120)) ([96b53f3](https://github.com/observeinc/terraform-aws-collection/commit/96b53f357eea31771f57b1f3ac13d72b33da79e1))
* **forwarder:** set name_prefix for eventbridge rule ([#124](https://github.com/observeinc/terraform-aws-collection/issues/124)) ([b082d1b](https://github.com/observeinc/terraform-aws-collection/commit/b082d1bbf0dbed9cab2cf8b5c932311bcf1a1a77))
* **logwriter:** adjust prefixes ([#129](https://github.com/observeinc/terraform-aws-collection/issues/129)) ([71cac60](https://github.com/observeinc/terraform-aws-collection/commit/71cac604b620174ce2d50a154c7491c864b8f322))
* **metricstream:** adjust prefixes ([#122](https://github.com/observeinc/terraform-aws-collection/issues/122)) ([42af24d](https://github.com/observeinc/terraform-aws-collection/commit/42af24d29b411d3b6546c864c987895c547dec72))
* rename collection mode ([#130](https://github.com/observeinc/terraform-aws-collection/issues/130)) ([da6d739](https://github.com/observeinc/terraform-aws-collection/commit/da6d7395e7179914834c046919055ca4eff67dec))
* update lambda binaries to v1.9.0 ([#123](https://github.com/observeinc/terraform-aws-collection/issues/123)) ([e847f05](https://github.com/observeinc/terraform-aws-collection/commit/e847f05b1189c58c80f21309bd12a9892d8b4bba))


### Features

* **forwarder:** add support for KMS decryption ([#119](https://github.com/observeinc/terraform-aws-collection/issues/119)) ([d0de5ef](https://github.com/observeinc/terraform-aws-collection/commit/d0de5ef2694f4dc7ef3b5bab887a70b4efccae93))
* **stack:** add debug_endpoint variable ([#131](https://github.com/observeinc/terraform-aws-collection/issues/131)) ([b04f6dc](https://github.com/observeinc/terraform-aws-collection/commit/b04f6dc00b815cfb7d74eb13fdaa72b4e9a58d6e))
* update dependencies ([#126](https://github.com/observeinc/terraform-aws-collection/issues/126)) ([eba1e86](https://github.com/observeinc/terraform-aws-collection/commit/eba1e8669a2fc2d464141bddfca8c8eb45ca3263))



# [2.9.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.8.0...v2.9.0) (2024-03-04)


### Bug Fixes

* **testing:** remove subscriptions module, use bucket_prefix ([#118](https://github.com/observeinc/terraform-aws-collection/issues/118)) ([2cafbc7](https://github.com/observeinc/terraform-aws-collection/commit/2cafbc77a0149cd788c1529bef5dd7418861d7ac))


### Features

* add debug_endpoint param for OTEL debugging ([c674e90](https://github.com/observeinc/terraform-aws-collection/commit/c674e90a2aad4f6268d492dafc33d1db56a206c7))


### Reverts

* Revert "chore(release): v2.8.0 [skip ci]" ([474f310](https://github.com/observeinc/terraform-aws-collection/commit/474f310511a9867ff1f037757c39f99ddc9e0116))



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



# [2.7.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.6.0...v2.7.0) (2024-02-02)


### Features

* add forwarder module ([#96](https://github.com/observeinc/terraform-aws-collection/issues/96)) ([0cccc44](https://github.com/observeinc/terraform-aws-collection/commit/0cccc44dc7fbb541042708847bf0358371c3c8f0))
* add logwriter ([6c18179](https://github.com/observeinc/terraform-aws-collection/commit/6c18179c75d74ca1dc0db8d641e6f59017d7ff25))
* bump kinesis firehose, s3 modules ([#101](https://github.com/observeinc/terraform-aws-collection/issues/101)) ([d079db9](https://github.com/observeinc/terraform-aws-collection/commit/d079db9131129f2263d85798d464c9070cf2917d))



# [2.6.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.5.1...v2.6.0) (2024-01-19)


### Features

* add testing modules ([#95](https://github.com/observeinc/terraform-aws-collection/issues/95)) ([9e986f0](https://github.com/observeinc/terraform-aws-collection/commit/9e986f01f87341ad6a8c76ab5ad13abb048aa72d))



## [2.5.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.5.0...v2.5.1) (2023-11-22)


### Bug Fixes

* **release:** empty commit to force a release that includes the lambda upgrade ([354193e](https://github.com/observeinc/terraform-aws-collection/commit/354193e138761672ded8620c6061bb54bef87f34))



# [2.5.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.4.1...v2.5.0) (2023-11-17)


### Features

* add AWS Config module ([#87](https://github.com/observeinc/terraform-aws-collection/issues/87)) ([b8b2d65](https://github.com/observeinc/terraform-aws-collection/commit/b8b2d6511c8dd81054f1db7d9ef7466ec96032a9))
* **config:** allow publishing to SNS topic ([#88](https://github.com/observeinc/terraform-aws-collection/issues/88)) ([0568081](https://github.com/observeinc/terraform-aws-collection/commit/0568081dfbe44223682a79e91a9e2ad5959609b8))
* **spec-tests:** introduce aws spec tests ([#85](https://github.com/observeinc/terraform-aws-collection/issues/85)) ([72e3c6c](https://github.com/observeinc/terraform-aws-collection/commit/72e3c6cb762706bb89026a0c856d07d13718d6eb))



## [2.4.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.4.0...v2.4.1) (2023-09-11)


### Bug Fixes

* flip default for invoke_snapshot_on_start to false ([#84](https://github.com/observeinc/terraform-aws-collection/issues/84)) ([8dcb990](https://github.com/observeinc/terraform-aws-collection/commit/8dcb990ff24a612733c76344880e0f56695462e9))



# [2.4.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.3.1...v2.4.0) (2023-08-03)


### Bug Fixes

* **snapshot:** adjust the snapshot include default settings ([#73](https://github.com/observeinc/terraform-aws-collection/issues/73)) ([f30c8d6](https://github.com/observeinc/terraform-aws-collection/commit/f30c8d6d7f998332cd3a698f87cd9a3e0c986a5c))


### Features

* **lambda:** add parameter for turning off lambda snapshot ([#75](https://github.com/observeinc/terraform-aws-collection/issues/75)) ([634bd49](https://github.com/observeinc/terraform-aws-collection/commit/634bd49d4e5306149a2ee6978e6e0582fdf1f6d4))



## [2.3.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.3.0...v2.3.1) (2023-07-18)


### Bug Fixes

* **Snapshot:** Reduce recurring snapshot time to 1hour ([#71](https://github.com/observeinc/terraform-aws-collection/issues/71)) ([9a99738](https://github.com/observeinc/terraform-aws-collection/commit/9a9973852993aea58c5682314766087476be10fc))



# [2.3.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.2.3...v2.3.0) (2023-07-15)


### Features

* **subscription:** subscribe to Lambda logs by default ([#69](https://github.com/observeinc/terraform-aws-collection/issues/69)) ([3fbfb8f](https://github.com/observeinc/terraform-aws-collection/commit/3fbfb8f41cfddcb21577c572beecec327d8438f4))



## [2.2.3](https://github.com/observeinc/terraform-aws-collection/compare/v2.2.2...v2.2.3) (2023-05-31)


### Bug Fixes

* bump firehose module to 2.0.1 ([#63](https://github.com/observeinc/terraform-aws-collection/issues/63)) ([68bd2c7](https://github.com/observeinc/terraform-aws-collection/commit/68bd2c79773c72da03f963277e6fb0be7f1620af))



## [2.2.2](https://github.com/observeinc/terraform-aws-collection/compare/v2.2.1...v2.2.2) (2023-05-15)


### Bug Fixes

* **s3:** set object ownership to ObjectWriter ([#61](https://github.com/observeinc/terraform-aws-collection/issues/61)) ([f5c4cb1](https://github.com/observeinc/terraform-aws-collection/commit/f5c4cb1e390a3d219df56888c9c9d5ffeb698c5d))



## [2.2.1](https://github.com/observeinc/terraform-aws-collection/compare/v2.2.0...v2.2.1) (2023-04-19)


### Bug Fixes

* adjust bucket ownership to allow ACLs ([#12](https://github.com/observeinc/terraform-aws-collection/issues/12)) ([#58](https://github.com/observeinc/terraform-aws-collection/issues/58)) ([3d21b77](https://github.com/observeinc/terraform-aws-collection/commit/3d21b774b2e6778ad01cf7bc66d480ea5e0ca43e))



# [2.2.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.1.0...v2.2.0) (2023-04-11)


### Features

* **deps:** bump observeinc/lambda/aws from 3.0.0 to 3.1.2 ([#56](https://github.com/observeinc/terraform-aws-collection/issues/56)) ([53fe121](https://github.com/observeinc/terraform-aws-collection/commit/53fe121a45e8ae99b9ddbe007f1590b864f014fb))
* **deps:** update terraform-aws-modules/s3-bucket/aws requirement from ~> 3.7.0 to ~> 3.8.2 ([#54](https://github.com/observeinc/terraform-aws-collection/issues/54)) ([45a5e8d](https://github.com/observeinc/terraform-aws-collection/commit/45a5e8dd70dea42c7155d0a76b5033a17d433c9f))



# [2.1.0](https://github.com/observeinc/terraform-aws-collection/compare/v2.0.0...v2.1.0) (2023-03-08)


### Features

* allow overriding `s3_bucket` ([#52](https://github.com/observeinc/terraform-aws-collection/issues/52)) ([3c9fa39](https://github.com/observeinc/terraform-aws-collection/commit/3c9fa39130c62f1fb7ecab7b1342edcf09ba6eb8))



# [2.0.0](https://github.com/observeinc/terraform-aws-collection/compare/v1.2.3...v2.0.0) (2023-03-03)


### Bug Fixes

* bump kinesis firehose module to 1.0.3 ([#44](https://github.com/observeinc/terraform-aws-collection/issues/44)) ([0758ee6](https://github.com/observeinc/terraform-aws-collection/commit/0758ee6e18f31566e2b69743ffd428b56f88bdee))


### Features

* allow opting out of cloudwatch metrics stream ([#48](https://github.com/observeinc/terraform-aws-collection/issues/48)) ([5777002](https://github.com/observeinc/terraform-aws-collection/commit/57770023e4c2b5aceef83eb2c80154bd6dac084f))
* allow overriding eventbridge rules ([#47](https://github.com/observeinc/terraform-aws-collection/issues/47)) ([e959300](https://github.com/observeinc/terraform-aws-collection/commit/e959300e52db615d7b055399d6bb6ac905203d05))
* allow overriding lambda memory_size and timeout ([#49](https://github.com/observeinc/terraform-aws-collection/issues/49)) ([7df81ee](https://github.com/observeinc/terraform-aws-collection/commit/7df81ee5b82a7dbbf3355ac08e1d1fe7b0be2e95))
* bump lambda module to 3.0.0 ([#50](https://github.com/observeinc/terraform-aws-collection/issues/50)) ([a4cc906](https://github.com/observeinc/terraform-aws-collection/commit/a4cc9060b7f6ec0e9c12ba51c103469b2d978679))



## [1.2.3](https://github.com/observeinc/terraform-aws-collection/compare/v1.2.2...v1.2.3) (2023-02-23)


### Bug Fixes

* add name variable for observe_cloudwatch_logs_subscription ([#33](https://github.com/observeinc/terraform-aws-collection/issues/33)) ([78a6420](https://github.com/observeinc/terraform-aws-collection/commit/78a6420b8a60ddca095444d7c778afcd00d3d29e))
* set `source` in `required_providers` ([#36](https://github.com/observeinc/terraform-aws-collection/issues/36)) ([1f27dca](https://github.com/observeinc/terraform-aws-collection/commit/1f27dca2f97793f3f3008d06daf8f94e754ea0c3))



## [1.2.2](https://github.com/observeinc/terraform-aws-collection/compare/v1.2.1...v1.2.2) (2023-02-17)


### Bug Fixes

* pass tags into subscription submodule ([#34](https://github.com/observeinc/terraform-aws-collection/issues/34)) ([245c47d](https://github.com/observeinc/terraform-aws-collection/commit/245c47d5737a297eb376ce342d1bde58ee3b11bc)), closes [#32](https://github.com/observeinc/terraform-aws-collection/issues/32)



## [1.2.1](https://github.com/observeinc/terraform-aws-collection/compare/v1.2.0...v1.2.1) (2023-02-13)


### Bug Fixes

* bump lambda module to 1.1.2 ([#30](https://github.com/observeinc/terraform-aws-collection/issues/30)) ([3ca7b04](https://github.com/observeinc/terraform-aws-collection/commit/3ca7b0441490b2f1a158a27f4148ffb92b691bb3))



# [1.2.0](https://github.com/observeinc/terraform-aws-collection/compare/v1.1.0...v1.2.0) (2023-01-18)


### Features

* variable to exclude kms/rds cloudtrail events ([#29](https://github.com/observeinc/terraform-aws-collection/issues/29)) ([36a330e](https://github.com/observeinc/terraform-aws-collection/commit/36a330ea18ec81645900929937161b8b6c165f7d)), closes [observeinc/cloudformation-aws-collection#3](https://github.com/observeinc/cloudformation-aws-collection/issues/3)



# [1.1.0](https://github.com/observeinc/terraform-aws-collection/compare/v1.0.0...v1.1.0) (2022-11-23)


### Features

* bump module versions, support AWS provider 4.0+ ([#28](https://github.com/observeinc/terraform-aws-collection/issues/28)) ([160b584](https://github.com/observeinc/terraform-aws-collection/commit/160b58413e00a610994a19e48d966427cbf7cfc0))



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



# [0.10.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.9.0...v0.10.0) (2022-04-20)


### Bug Fixes

* allow setting reserved_concurrent_executions ([#19](https://github.com/observeinc/terraform-aws-collection/issues/19)) ([31097a2](https://github.com/observeinc/terraform-aws-collection/commit/31097a22bc677217a3cdca7cb8237074c24a696d))


### Features

* allow filtering on cloudwatch metrics by namespace ([#18](https://github.com/observeinc/terraform-aws-collection/issues/18)) ([0713fbb](https://github.com/observeinc/terraform-aws-collection/commit/0713fbbf84ef3c8bdc124c394322c2fefade7506))
* bump lambda to v0.13.0 ([#20](https://github.com/observeinc/terraform-aws-collection/issues/20)) ([e590d30](https://github.com/observeinc/terraform-aws-collection/commit/e590d3011646b89aaa369b7840e152b02354dc45))



# [0.9.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.8.0...v0.9.0) (2022-02-17)


### Bug Fixes

* pin AWS provider to v3.X ([#15](https://github.com/observeinc/terraform-aws-collection/issues/15)) ([ea37049](https://github.com/observeinc/terraform-aws-collection/commit/ea37049842dfe9c62b94142110b09d0616b016ff))


### Features

* bump terraform-aws-kinesis-firehose to v0.4.0 ([#16](https://github.com/observeinc/terraform-aws-collection/issues/16)) ([48251f3](https://github.com/observeinc/terraform-aws-collection/commit/48251f3348e54a89f72ed308d528324baff6af8c))
* update lambda module to v0.12.0 ([#17](https://github.com/observeinc/terraform-aws-collection/issues/17)) ([d85e407](https://github.com/observeinc/terraform-aws-collection/commit/d85e407d681fd934939fb0ec978dc085e22178d0))



# [0.8.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.7.0...v0.8.0) (2022-01-31)


### Bug Fixes

* remove action variable, allow falling back to default ([#12](https://github.com/observeinc/terraform-aws-collection/issues/12)) ([294b4c3](https://github.com/observeinc/terraform-aws-collection/commit/294b4c3ad3986eb51516eae213f0c915a13792ab))


### Features

* allow overriding snapshot schedule expression ([#13](https://github.com/observeinc/terraform-aws-collection/issues/13)) ([6af773a](https://github.com/observeinc/terraform-aws-collection/commit/6af773a0a42a92fd5589d8d68d552b0e0cd6c8ec))
* update lambda module to v0.11.0 ([#14](https://github.com/observeinc/terraform-aws-collection/issues/14)) ([4482041](https://github.com/observeinc/terraform-aws-collection/commit/4482041c7f1a47ee8f58ce8748894951cf9259ac))



# [0.7.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.6.0...v0.7.0) (2022-01-14)


### Bug Fixes

* update terraform-aws-lambda to v0.9.0 ([#11](https://github.com/observeinc/terraform-aws-collection/issues/11)) ([afec5f1](https://github.com/observeinc/terraform-aws-collection/commit/afec5f15b8222093fc2adea937e548bf1f733a81))


### Features

* add `cloudtrail_enable_log_validation` option ([#10](https://github.com/observeinc/terraform-aws-collection/issues/10)) ([042e0e1](https://github.com/observeinc/terraform-aws-collection/commit/042e0e1922d7526997d1a9eb93dd25e4b09b13f3))



# [0.6.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.5.0...v0.6.0) (2022-01-03)


### Features

* add kms_key_id to cloudtrail ([#9](https://github.com/observeinc/terraform-aws-collection/issues/9)) ([ce313a8](https://github.com/observeinc/terraform-aws-collection/commit/ce313a86a0ccc734b767156c717f8cea5e2ddf6c))



# [0.5.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.4.0...v0.5.0) (2021-11-29)


### Features

* allow specifying additional s3 buckets ([#8](https://github.com/observeinc/terraform-aws-collection/issues/8)) ([ce9b011](https://github.com/observeinc/terraform-aws-collection/commit/ce9b011a11b091ea73026d1f7a58d8d765a92f7d))



# [0.4.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.3.0...v0.4.0) (2021-11-17)


### Bug Fixes

* expand permissions to include s3:GetBucketTagging ([#6](https://github.com/observeinc/terraform-aws-collection/issues/6)) ([7beddff](https://github.com/observeinc/terraform-aws-collection/commit/7beddffcb38357e08ca48b1f0091c2584971087b))



# [0.3.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.2.0...v0.3.0) (2021-09-23)


### Features

* allow overriding actions in snapshot module ([3adf265](https://github.com/observeinc/terraform-aws-collection/commit/3adf2655ed689e55f305d6dcf72993d76adfff77))
* extend default actions ([#4](https://github.com/observeinc/terraform-aws-collection/issues/4)) ([e568efc](https://github.com/observeinc/terraform-aws-collection/commit/e568efc5a5cf943e6e5255b3eedfc2f4ae3e1a17))



# [0.2.0](https://github.com/observeinc/terraform-aws-collection/compare/v0.1.0...v0.2.0) (2021-08-23)


### Features

* upgrade terraform-aws-lambda to 0.7.0 ([255d420](https://github.com/observeinc/terraform-aws-collection/commit/255d420d9407d423eda5c0f987e4f7e56888419d))



# 0.1.0 (2021-07-22)



