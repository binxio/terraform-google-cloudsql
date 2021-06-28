locals {
  owner       = var.owner
  project     = var.project
  environment = var.environment
  purpose     = var.purpose

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
    }

    postgresql = {
      database_version = "POSTGRES_11"
      database_defaults = {
        collation = ""
        charset   = ""
      }
    }
  }

  default_ip_configuration = {
    ipv4_enabled        = false
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }

  default_maintenance_window = {
    day          = 4
    hour         = 10
    update_track = "stable"
  }

  module_settings_defaults = {
    activation_policy    = "ALWAYS"
    availability_type    = var.engine == "postgresql" ? "ZONAL" : null // not available for mysql
    disk_size            = 10
    pricing_plan         = "PER_USE"
    tier                 = "db-n1-standard-1"
    user_labels          = {}
    database_flags       = []
    maintenance_window   = local.default_maintenance_window
    ip_configuration     = local.default_ip_configuration
    backup_configuration = {}
  }

  module_replica_settings_defaults = {
    activation_policy  = "ALWAYS"
    availability_type  = var.engine == "postgresql" ? "ZONAL" : null // not available for mysql
    disk_size          = 10
    pricing_plan       = "PER_USE"
    tier               = "db-n1-standard-1"
    database_flags     = []
    maintenance_window = local.default_maintenance_window
    ip_configuration   = local.default_ip_configuration
  }

  # Merge defaults with module defaults and user provided variables
  defaults = local.module_defaults[var.engine]
  settings_defaults = var.settings_defaults == null ? local.module_settings_defaults : merge(
    local.module_settings_defaults,
    var.settings_defaults,
    {
      ip_configuration = merge(
        local.module_settings_defaults.ip_configuration,
        try(var.settings_defaults.ip_configuration, {})
      )
      maintenance_window = merge(
        local.module_settings_defaults.maintenance_window,
        try(var.settings_defaults.maintenance_window, {})
      )
      backup_configuration = merge(
        {
          binary_log_enabled             = var.engine == "mysql" ? true : null      // not available for postgresql
          point_in_time_recovery_enabled = var.engine == "postgresql" ? true : null // not available for mysql
          enabled                        = true
          start_time                     = "03:30"
        },
        try(var.settings_defaults.backup_configuration, {})
      )
    }
  )
  read_replica_settings_defaults = var.read_replica_settings_defaults == null ? local.module_replica_settings_defaults : merge(
    local.module_replica_settings_defaults,
    var.read_replica_settings_defaults,
    {
      ip_configuration = merge(
        local.module_replica_settings_defaults.ip_configuration,
        try(var.read_replica_settings.ip_configuration, {})
      )
      maintenance_window = merge(
        local.module_replica_settings_defaults.maintenance_window,
        try(var.read_replica_settings.maintenance_window, {})
      )
    }
  )

  labels = merge(local.settings.user_labels, {
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

  database_version    = coalesce(var.database_version, local.defaults.database_version)
  region              = var.region
  settings            = merge(local.settings_defaults, var.settings)
  deletion_protection = var.deletion_protection

  master_instance_name = google_sql_database_instance.master.name

  ###############################################
  #                                             #
  # Read replica settings                       #
  #                                             #
  ###############################################
  read_replica = {
    settings = merge(local.read_replica_settings_defaults, var.read_replica_settings)

    replica_configuration = merge({
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
    }, var.read_replica_configuration)
  }
}

resource "random_id" "rid" {
  byte_length = 2
}
