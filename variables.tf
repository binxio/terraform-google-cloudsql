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

variable "disk_size" {
  description = "The disk size for the master instance"
  type        = number
  default     = 10
}
variable "pricing_plan" {
  description = "The pricing plan for the master instance."
  type        = string
  default     = "PER_USE"
}
variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-n1-standard-1"
}
variable "activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}
variable "authorized_gae_applications" {
  description = "The list of authorized App Engine project names"
  type        = list(string)
  default     = []
}
variable "availability_type" {
  description = "The availability type for the master instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "The maintenance_window configuration."
  type = object({
    day          = number
    hour         = number
    update_track = string
  })
  default = {
    day          = 4
    hour         = 10
    update_track = "stable"
  }
}

variable "ip_configuration" {
  description = "The ip configuration for the master instances."
  default = {
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "backup_configuration" {
  description = <<EOF
The backup configuration block of the Cloud SQL resources
This argument will be passed through the master instance directrly.

See [more details](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html).
EOF
  default     = {}
}

variable "defaults" {
  description = "Override defaults provided by the module itself"
  default     = {}
}

variable "user_labels" {
  description = "The key/value labels for the master instances."
  type        = map(string)
  default     = {}
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

variable "read_replica_pricing_plan" {
  description = "The pricing plan for the master instance."
  type        = string
  default     = "PER_USE"
}
variable "read_replica_tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-n1-standard-1"
}
variable "read_replica_activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}
variable "read_replica_authorized_gae_applications" {
  description = "The list of authorized App Engine project names"
  type        = list(string)
  default     = []
}
variable "read_replica_availability_type" {
  description = "The availability type for the master instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = null
}

variable "read_replica_maintenance_window" {
  description = "The maintenance_window configuration."
  type = object({
    day          = number
    hour         = number
    update_track = string
  })
  default = {
    day          = 4
    hour         = 10
    update_track = "stable"
  }
}

variable "read_replica_ip_configuration" {
  description = "The ip configuration for the master instances."
  default = {
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }
}

variable "read_replica_database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "read_replica_crash_safe_replication" {
  description = "The crash safe replication is to indicates when crash-safe replication flags are enabled."
  type        = bool
  default     = true
}

variable "read_replica_replication_type" {
  description = "The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS."
  type        = string
  default     = "SYNCHRONOUS"
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

variable "failover_replica_pricing_plan" {
  description = "The pricing plan for the master instance."
  type        = string
  default     = "PER_USE"
}
variable "failover_replica_tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-n1-standard-1"
}
variable "failover_replica_activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}
variable "failover_replica_authorized_gae_applications" {
  description = "The list of authorized App Engine project names"
  type        = list(string)
  default     = []
}
variable "failover_replica_availability_type" {
  description = "The availability type for the master instance. This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = null
}

variable "failover_replica_maintenance_window" {
  description = "The maintenance_window configuration."
  type = object({
    day          = number
    hour         = number
    update_track = string
  })
  default = {
    day          = 4
    hour         = 10
    update_track = "stable"
  }
}

variable "failover_replica_ip_configuration" {
  description = "The ip configuration for the master instances."
  default = {
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }
}

variable "failover_replica_database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "failover_replica_crash_safe_replication" {
  description = "The crash safe replication is to indicates when crash-safe replication flags are enabled."
  type        = bool
  default     = true
}

variable "failover_replica_replication_type" {
  description = "The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS."
  type        = string
  default     = "SYNCHRONOUS"
}
