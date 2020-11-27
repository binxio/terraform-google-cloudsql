#------------------------------------------------------------------------------------------------------------------------
# 
# Generic variables
#
#------------------------------------------------------------------------------------------------------------------------
variable "owner" {
  description = "Owner of the resource. This variable is used to set the 'owner' label. Will be used as default for each subnet, but can be overridden using the subnet settings."
  type        = string
}

variable "project" {
  description = "Company project name."
  type        = string
}

variable "environment" {
  description = "Company environment for which the resources are created (e.g. dev, tst, acc, prd, all)."
  type        = string
}

variable "purpose" {
  description = "The purpose of the SQL instance. This variable is appended to the instance name and used to set the 'name' label."
  type        = string
}

#------------------------------------------------------------------------------------------------------------------------
#
# cloudsql variables
#
#------------------------------------------------------------------------------------------------------------------------

variable "engine" {
  description = "Engine to use for defaults, can by either 'postgresql' or 'mysql'"
  type        = string
  default     = "mysql"
}

variable "database_version" {
  description = "The database version to use"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region of the Cloud SQL resources"
  type        = string
  default     = "europe-west4"
}


variable "settings" {
  description = <<EOF
Configuration object of the settings to be used for the master instance:
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
EOF

  type    = any
  default = null
}

variable "settings_defaults" {
  description = "Override defaults provided by the module itself"
  type = object({
    activation_policy = string
    availability_type = string
    disk_size         = number
    pricing_plan      = string
    tier              = string
    user_labels       = map(string)

    maintenance_window = object({
      day          = number
      hour         = number
      update_track = string
    })
    ip_configuration = object({
      ipv4_enabled        = bool
      require_ssl         = bool
      private_network     = string
      authorized_networks = list(string)
    })
    database_flags = list(object({
      name  = string
      value = string
    }))
    backup_configuration = object({
      binary_log_enabled             = bool
      enabled                        = bool
      start_time                     = string
      point_in_time_recovery_enabled = bool
    })
  })
  default = null
}

variable "databases" {
  description = "List of databases to create"
  type        = map(any)
  default     = {}
}

variable "database_defaults" {
  description = "Defaults to use for cloud sql database"
  type = object({
    collation = string
    charset   = string
  })
  default = {
    collation = ""
    charset   = ""
  }
}

variable "admin_user" {
  description = "The user used for the db connection to create new users"
  type        = string
  default     = "root"
}

variable "admin_user_password_cipher" {
  description = "KMS encrypted password for the admin user. You can choose to provide a Secret Manager secret instead using the `admin_user_password_secret` variable"
  type        = string
  default     = ""
}

variable "admin_user_crypto_key" {
  description = "The KMS key used to encrypt the admin user password. You can choose to provide a Secret Manager secret instead using the `admin_user_password_secret` variable"
  type        = string
  default     = ""
}

variable "admin_user_password_secret" {
  description = "Secret Manager Secret reference for the Admin user password. You can choose to provide a KMS crypto key and Cipher instead."
  type        = string
  default     = ""
}

variable "admin_user_password_secret_version" {
  description = "Optional version to be used if a Secret Manager Secret is provided for the Admin user password."
  type        = string
  default     = null
}

// Read Replicas
variable "read_replica_size" {
  description = "The size of read replicas"
  type        = number
  default     = 0
}

variable "read_replica_configuration" {
  description = "The replica configuration for the read replica instances."
  default     = {}
}

variable "read_replica_settings" {
  description = <<EOF
Configuration object of the settings to be used for the read replica instance:
  * `activation_policy` The activation policy for the read replica instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
  * `availability_type` The availability type for the read replica instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.
  * `pricing_plan`
  * `tier`
	* `maintenance_window` Configuration object for the maintenance_window
	* `ip_configuration` Configuration object for the ip configuration
  * `database_flags` The database flags for the instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)
EOF

  type    = any
  default = null
}

variable "read_replica_settings_defaults" {
  description = "Override defaults provided by the module itself"
  type = object({
    activation_policy = string
    availability_type = string
    pricing_plan      = string
    tier              = string

    maintenance_window = object({
      day          = number
      hour         = number
      update_track = string
    })
    ip_configuration = object({
      ipv4_enabled        = bool
      require_ssl         = bool
      private_network     = string
      authorized_networks = list(string)
    })
    database_flags = list(object({
      name  = string
      value = string
    }))
  })
  default = null
}

// Failover Replica
variable "failover_replica" {
  description = "Specify true if the failover instance is required"
  type        = bool
  default     = false
}

variable "failover_replica_configuration" {
  description = "The replica configuration for the failover replica instance. In order to create a failover instance, need to specify this argument."
  default     = {}
}

variable "failover_replica_size" {
  description = "The size of read replicas"
  type        = number
  default     = 0
}

variable "failover_replica_settings" {
  description = <<EOF
Configuration object of the settings to be used for the failover replica instance:
  * `activation_policy` The activation policy for the failover replica instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
  * `availability_type` The availability type for the failover replica instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`.
  * `pricing_plan`
  * `tier`
	* `maintenance_window` Configuration object for the maintenance_window
	* `ip_configuration` Configuration object for the ip configuration
  * `database_flags` The database flags for the instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)
EOF

  type    = any
  default = null
}

variable "failover_replica_settings_defaults" {
  description = "Override defaults provided by the module itself"
  type = object({
    activation_policy = string
    availability_type = string
    pricing_plan      = string
    tier              = string

    maintenance_window = object({
      day          = number
      hour         = number
      update_track = string
    })
    ip_configuration = object({
      ipv4_enabled        = bool
      require_ssl         = bool
      private_network     = string
      authorized_networks = list(string)
    })
    database_flags = list(object({
      name  = string
      value = string
    }))
  })
  default = null
}
