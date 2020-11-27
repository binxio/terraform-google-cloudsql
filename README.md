
# Module `terraform-google-cloudsql`

Core Version Constraints:
* `>= 0.13`

Provider Requirements:
* **google (`hashicorp/google`):** (any version)
* **random:** (any version)

## Input Variables
* `activation_policy` (default `"ALWAYS"`): The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
* `admin_user` (default `"root"`): The user used for the db connection to create new users
* `admin_user_crypto_key` (required): The KMS key used to encrypt the admin user password. You can choose to provide a Secret Manager secret instead using the `admin_user_password_secret` variable
* `admin_user_password_cipher` (required): KMS encrypted password for the admin user. You can choose to provide a Secret Manager secret instead using the `admin_user_password_secret` variable
* `admin_user_password_secret` (required): Secret Manager Secret reference for the Admin user password. You can choose to provide a KMS crypto key and Cipher instead.
* `admin_user_password_secret_version` (required): Optional version to be used if a Secret Manager Secret is provided for the Admin user password.
* `authorized_gae_applications` (required): The list of authorized App Engine project names
* `availability_type` (required): The availability type for the master instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.
* `backup_configuration` (required): The backup configuration block of the Cloud SQL resources
This argument will be passed through the master instance directrly.

See [more details](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html).

* `database_defaults` (default `{"charset":"","collation":""}`): Defaults to use for cloud sql database
* `database_flags` (required): The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)
* `database_version` (required): The database version to use
* `databases` (required): List of databases to create
* `defaults` (required): Override defaults provided by the module itself
* `disk_size` (default `10`): The disk size for the master instance
* `engine` (default `"mysql"`): Engine to use for defaults, can by either 'postgresql' or 'mysql'
* `environment` (required): Company environment for which the resources are created (e.g. dev, tst, acc, prd, all).
* `failover_replica` (required): Specify true if the failover instance is required
* `failover_replica_activation_policy` (default `"ALWAYS"`): The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
* `failover_replica_authorized_gae_applications` (required): The list of authorized App Engine project names
* `failover_replica_availability_type` (required): The availability type for the master instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.
* `failover_replica_configuration` (required): The replica configuration for the failover replica instance. In order to create a failover instance, need to specify this argument.
* `failover_replica_crash_safe_replication` (default `true`): The crash safe replication is to indicates when crash-safe replication flags are enabled.
* `failover_replica_database_flags` (required): The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)
* `failover_replica_ip_configuration` (default `{"authorized_networks":[],"ipv4_enabled":false,"private_network":null,"require_ssl":true}`): The ip configuration for the master instances.
* `failover_replica_maintenance_window` (default `{"day":4,"hour":10,"update_track":"stable"}`): The maintenance_window configuration.
* `failover_replica_pricing_plan` (default `"PER_USE"`): The pricing plan for the master instance.
* `failover_replica_replication_type` (default `"SYNCHRONOUS"`): The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS.
* `failover_replica_size` (required): The size of read replicas
* `failover_replica_tier` (default `"db-n1-standard-1"`): The tier for the master instance.
* `ip_configuration` (default `{"authorized_networks":[],"ipv4_enabled":false,"private_network":null,"require_ssl":true}`): The ip configuration for the master instances.
* `maintenance_window` (default `{"day":4,"hour":10,"update_track":"stable"}`): The maintenance_window configuration.
* `owner` (required): Owner of the resource. This variable is used to set the 'owner' label. Will be used as default for each subnet, but can be overridden using the subnet settings.
* `pricing_plan` (default `"PER_USE"`): The pricing plan for the master instance.
* `project` (required): Company project name.
* `purpose` (required): The purpose of the SQL instance. This variable is appended to the instance name and used to set the 'name' label.
* `read_replica_activation_policy` (default `"ALWAYS"`): The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
* `read_replica_authorized_gae_applications` (required): The list of authorized App Engine project names
* `read_replica_availability_type` (required): The availability type for the master instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.
* `read_replica_configuration` (required): The replica configuration for the read replica instances.
* `read_replica_crash_safe_replication` (default `true`): The crash safe replication is to indicates when crash-safe replication flags are enabled.
* `read_replica_database_flags` (required): The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)
* `read_replica_ip_configuration` (default `{"authorized_networks":[],"ipv4_enabled":false,"private_network":null,"require_ssl":true}`): The ip configuration for the master instances.
* `read_replica_maintenance_window` (default `{"day":4,"hour":10,"update_track":"stable"}`): The maintenance_window configuration.
* `read_replica_pricing_plan` (default `"PER_USE"`): The pricing plan for the master instance.
* `read_replica_replication_type` (default `"SYNCHRONOUS"`): The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS.
* `read_replica_size` (required): The size of read replicas
* `read_replica_tier` (default `"db-n1-standard-1"`): The tier for the master instance.
* `region` (default `"europe-west4"`): The region of the Cloud SQL resources
* `tier` (default `"db-n1-standard-1"`): The tier for the master instance.
* `user_labels` (required): The key/value labels for the master instances.

## Output Values
* `defaults`: The generic defaults used for MySQL and Postgres specific settings
* `instance_connection_name`: The connection name of the master instance to be used in connection strings
* `instance_first_ip_address`: The first IPv4 address of the addresses assigned for the master instance.
* `instance_ip_address`: The IPv4 address assigned for the master instance
* `instance_name`: The instance name for the master instance
* `instance_self_link`: The URI of the master instance
* `instance_server_ca_cert`: The CA certificate information used to connect to the SQL instance via SSL
* `instance_service_account_email_address`: The service account email address assigned to the master instance
* `read_replica_instance_names`: The instance names for the read replica instances
* `replicas_instance_connection_names`: The connection names of the replica instances to be used in connection strings
* `replicas_instance_first_ip_addresses`: The first IPv4 addresses of the addresses assigned for the replica instances
* `replicas_instance_self_links`: The URIs of the replica instances
* `replicas_instance_server_ca_certs`: The CA certificates information used to connect to the replica instances via SSL
* `replicas_instance_service_account_email_addresses`: The service account email addresses assigned to the replica instances

## Managed Resources
* `google_sql_database.map` from `google`
* `google_sql_database_instance.failover` from `google`
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
