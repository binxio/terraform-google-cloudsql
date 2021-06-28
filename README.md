
# Module `terraform-google-cloudsql`

Core Version Constraints:
* `>= 0.13`

Provider Requirements:
* **google (`hashicorp/google`):** (any version)
* **random:** (any version)

## Input Variables
* `admin_user` (default `"root"`): The user used for the db connection to create new users
* `admin_user_crypto_key` (default `""`): The KMS key used to encrypt the admin user password. You can choose to provide a Secret Manager secret instead using the `admin_user_password_secret` variable
* `admin_user_password_cipher` (default `""`): KMS encrypted password for the admin user. You can choose to provide a Secret Manager secret instead using the `admin_user_password_secret` variable
* `admin_user_password_secret` (default `""`): Secret Manager Secret reference for the Admin user password. You can choose to provide a KMS crypto key and Cipher instead.
* `admin_user_password_secret_version` (default `null`): Optional version to be used if a Secret Manager Secret is provided for the Admin user password.
* `database_defaults` (default `{"charset":"","collation":""}`): Defaults to use for cloud sql database
* `database_version` (default `""`): The database version to use
* `databases` (default `{}`): List of databases to create
* `engine` (default `"mysql"`): Engine to use for defaults, can by either 'postgresql' or 'mysql'
* `environment` (required): Company environment for which the resources are created (e.g. dev, tst, acc, prd, all).
* `owner` (required): Owner of the resource. This variable is used to set the 'owner' label. Will be used as default for each subnet, but can be overridden using the subnet settings.
* `project` (required): Company project name.
* `purpose` (required): The purpose of the SQL instance. This variable is appended to the instance name and used to set the 'name' label.
* `read_replica_configuration` (default `{}`): The replica configuration for the read replica instances.
* `read_replica_settings` (default `null`): Configuration object of the settings to be used for the read replica instance:
  * `activation_policy` The activation policy for the read replica instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
  * `availability_type` The availability type for the read replica instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.
  * `pricing_plan`
  * `tier`
	* `maintenance_window` Configuration object for the maintenance_window
	* `ip_configuration` Configuration object for the ip configuration
  * `database_flags` The database flags for the instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)

* `read_replica_settings_defaults` (default `null`): Override defaults provided by the module itself
* `read_replica_size` (default `0`): The size of read replicas
* `region` (default `"europe-west4"`): The region of the Cloud SQL resources
* `settings` (default `null`): Configuration object of the settings to be used for the master instance:
  * `activation_policy` The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
  * `availability_type` The availability type for the master instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.
  * `disk_size`
  * `pricing_plan`
  * `tier`
  * `user_labels`
	* `maintenance_window` Configuration object for the maintenance_window
	* `ip_configuration` Configuration object for the ip configuration
  * `database_flags` The database flags for the instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)
  * `backup_configuration` The backup configuration block of the Cloud SQL resources. This argument will be passed through the master instance directly.  See [more details](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html).

* `settings_defaults` (default `null`): Override defaults provided by the module itself

## Output Values
* `instance_connection_name`: The connection name of the master instance to be used in connection strings
* `instance_first_ip_address`: The first IPv4 address of the addresses assigned for the master instance.
* `instance_ip_address`: The IPv4 address assigned for the master instance
* `instance_name`: The instance name for the master instance
* `instance_self_link`: The URI of the master instance
* `instance_server_ca_cert`: The CA certificate information used to connect to the SQL instance via SSL
* `instance_service_account_email_address`: The service account email address assigned to the master instance
* `read_replica_instance_names`: The instance names for the read replica instances
* `replica_settings_defaults`: The read replica settings defaults used
* `replicas_instance_connection_names`: The connection names of the replica instances to be used in connection strings
* `replicas_instance_first_ip_addresses`: The first IPv4 addresses of the addresses assigned for the replica instances
* `replicas_instance_self_links`: The URIs of the replica instances
* `replicas_instance_server_ca_certs`: The CA certificates information used to connect to the replica instances via SSL
* `replicas_instance_service_account_email_addresses`: The service account email addresses assigned to the replica instances
* `settings_defaults`: The master settings defaults used

## Managed Resources
* `google_sql_database.map` from `google`
* `google_sql_database_instance.master` from `google`
* `google_sql_database_instance.read` from `google`
* `google_sql_user.admin_user_kms` from `google`
* `random_id.rid` from `random`

## Data Resources
* `data.google_kms_secret.admin_password` from `google`
* `data.google_secret_manager_secret_version.admin_password` from `google`

## Creating a new release
After adding your changed and committing the code to GIT, you will need to add a new tag.
```
git tag vx.x.x
git push --tag
```
If your changes might be breaking current implementations of this module, make sure to bump the major version up by 1.

If you want to see which tags are already there, you can use the following command:
```
git tag --list
```
Required APIs
=============
For the VPC services to deploy, the following APIs should be enabled in your project:
 * `iam.googleapis.com`
 * `sqladmin.googleapis.com`

Testing
=======
This module comes with [terratest](https://github.com/gruntwork-io/terratest) scripts for both unit testing and integration testing.
A Makefile is provided to run the tests using docker, but you can also run the tests directly on your machine if you have terratest installed.

### Run with make
Make sure to set GOOGLE_CLOUD_PROJECT to the right project and GOOGLE_CREDENTIALS to the right credentials json file
You can now run the tests with docker:
```
make test
```

### Run locally
From the module directory, run:
```
cd test && TF_VAR_owner=$(id -nu) go test
```
