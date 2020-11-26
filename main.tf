locals {
  owner       = var.owner
  project     = var.project
  environment = var.environment
  purpose     = local.purpose

  instance_name_no_random = replace(format("%s-%s-%s", local.project, local.environment, lower(local.purpose)), " ", "-")
  instance_name           = format("%s-%s", local.instance_name_no_random, random_id.rid.hex)

  # Startpoint for our database defaults
  module_defaults = {
    mysql = {
      database_version = "MYSQL_5_7"
      database_defaults = {
        collation = ""
        charset   = ""
      }
      availability_type = null // not available for MySQL
      backup_configuration = {
        binary_log_enabled = true
        enabled            = true
        start_time         = "03:30"
      }
      database_flags = []
    }

    postgresql = {
      database_version = "POSTGRES_11"
      database_defaults = {
        collation = ""
        charset   = ""
      }
      availability_type = "ZONAL"
      backup_configuration = {
        binary_log_enabled = null // not available for postgresql
        enabled            = true
        start_time         = "03:30"
      }
      database_flags = []
    }
  }

  # Merge defaults with module defaults and user provided variables
  defaults = merge(local.module_defaults[var.engine], var.defaults)

  labels = merge(var.user_labels, {
    "project" = substr(replace(lower(local.project), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
    "env"     = substr(replace(lower(local.environment), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
    "owner"   = substr(replace(lower(local.owner), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
    "purpose" = substr(replace(lower(local.purpose), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
    "creator" = "terraform"
  }) # Make sure mandatory labels are there

  ###############################################
  #                                             #
  # Master settings                             #
  #                                             #
  ###############################################

  # Make sure all mandatory ip_configuration settings are present
  ip_configuration = merge({
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }, var.ip_configuration)

  merged = {
    database_version = coalesce(var.database_version, local.defaults.database_version)
    region           = var.region

    disk_size                   = var.disk_size
    pricing_plan                = var.pricing_plan
    tier                        = var.tier
    activation_policy           = var.activation_policy
    authorized_gae_applications = var.authorized_gae_applications
    availability_type           = (var.availability_type == null ? local.defaults.availability_type : var.availability_type)

    backup_configuration = merge(local.defaults.backup_configuration, var.backup_configuration)
    database_flags       = concat(local.defaults.database_flags, var.database_flags)
    maintenance_window   = var.maintenance_window
    ip_configuration     = local.ip_configuration
  }

  ###############################################
  #                                             #
  # Read replica settings                       #
  #                                             #
  ###############################################

  # Make sure all mandatory ip_configuration settings are present
  read_replica_ip_configuration = merge({
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }, var.read_replica_ip_configuration)

  read_replica_merged = {
    master_instance_name = google_sql_database_instance.master.name
    database_version     = coalesce(var.database_version, local.defaults.database_version)
    region               = var.region

    disk_size                   = var.disk_size
    pricing_plan                = var.read_replica_pricing_plan
    tier                        = var.read_replica_tier
    activation_policy           = var.read_replica_activation_policy
    authorized_gae_applications = var.read_replica_authorized_gae_applications
    availability_type           = (var.read_replica_availability_type == null ? local.defaults.availability_type : var.read_replica_availability_type)

    crash_safe_replication = var.read_replica_crash_safe_replication
    replication_type       = var.read_replica_replication_type

    database_flags     = concat(local.defaults.database_flags, var.read_replica_database_flags)
    maintenance_window = var.read_replica_maintenance_window
    ip_configuration   = local.read_replica_ip_configuration

    replica_configuration = merge(var.read_replica_configuration, {
      ca_certificate            = null
      client_certificate        = null
      client_key                = null
      connect_retry_interval    = 60
      dump_file_path            = null
      master_heartbeat_period   = null
      password                  = null
      ssl_cipher                = null
      username                  = null
      verify_server_certificate = null
    })
  }

  ###############################################
  #                                             #
  # Failover replica settings                   #
  #                                             #
  ###############################################

  failover_instance_name = google_sql_database_instance.master.name

  # Make sure all mandatory ip_configuration settings are present
  failover_replica_ip_configuration = merge({
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }, var.failover_replica_ip_configuration)

  failover_replica_merged = {
    master_instance_name = google_sql_database_instance.master.name
    database_version     = coalesce(var.database_version, local.defaults.database_version)
    region               = var.region

    disk_size                   = var.disk_size
    pricing_plan                = var.failover_replica_pricing_plan
    tier                        = var.failover_replica_tier
    activation_policy           = var.failover_replica_activation_policy
    authorized_gae_applications = var.failover_replica_authorized_gae_applications
    availability_type           = (var.failover_replica_availability_type == null ? local.defaults.availability_type : var.failover_replica_availability_type)

    crash_safe_replication = var.failover_replica_crash_safe_replication
    replication_type       = var.failover_replica_replication_type

    database_flags     = concat(local.defaults.database_flags, var.failover_replica_database_flags)
    maintenance_window = var.failover_replica_maintenance_window
    ip_configuration   = local.failover_replica_ip_configuration

    replica_configuration = merge(var.failover_replica_configuration, {
      ca_certificate            = null
      client_certificate        = null
      client_key                = null
      connect_retry_interval    = 60
      dump_file_path            = null
      master_heartbeat_period   = null
      password                  = null
      ssl_cipher                = null
      username                  = null
      verify_server_certificate = null
    })
  }
}

resource "random_id" "rid" {
  byte_length = 2
}
