# Changelog

## v2.0.0 (2021-06-28)

### Changes

* legacy failover instance has been removed (should use REGIONAL availability_type instead)
* you can now provide the deletion_protection setting (default true)

## v1.1.1 (2021-03-11)

* [FIX] Properly pass point_in_time_recovery_enabled backup configuration option.

## v1.1.0 (2020-11-27)

* Re-organization of variables

### Fixes

The cloudsql instance settings are now passed through the `settings` variable making it more in line with the terraform resource itself

## v1.0.0 (2020-11-23)

* Initial release

### Features

* Initial release of this module based on Terraform 0.13
