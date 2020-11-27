resource "google_sql_database_instance" "master" {
  name = local.instance_name

  database_version = local.merged.database_version
  region           = local.merged.region

  settings {
    disk_autoresize             = true
    disk_size                   = local.merged.disk_size
    pricing_plan                = local.merged.pricing_plan
    tier                        = local.merged.tier
    activation_policy           = local.merged.activation_policy
    authorized_gae_applications = local.merged.authorized_gae_applications
    availability_type           = local.merged.availability_type
    user_labels                 = merge({ instance_type = "master" }, local.labels)

    backup_configuration {
      binary_log_enabled = local.merged.backup_configuration.binary_log_enabled
      enabled            = local.merged.backup_configuration.enabled
      start_time         = local.merged.backup_configuration.start_time
    }

    maintenance_window {
      day          = local.merged.maintenance_window.day
      hour         = local.merged.maintenance_window.hour
      update_track = local.merged.maintenance_window.update_track
    }

    ip_configuration {
      ipv4_enabled    = local.merged.ip_configuration.ipv4_enabled
      require_ssl     = local.merged.ip_configuration.require_ssl
      private_network = local.merged.ip_configuration.private_network

      dynamic "authorized_networks" {
        for_each = local.merged.ip_configuration.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    dynamic "database_flags" {
      for_each = local.merged.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }
  }

  lifecycle {
    ignore_changes = [
      public_ip_address,
      settings[0].disk_size,
      settings[0].ip_configuration["ipv4_enabled"],
      settings[0].ip_configuration[0].ipv4_enabled,
      settings[0].version,
    ]
  }
}

resource "google_sql_database" "map" {
  for_each = { for name, settings in var.databases : name => merge(var.defaults[var.engine].database_defaults, settings) }

  name      = each.key
  instance  = google_sql_database_instance.master.name
  charset   = each.value.charset
  collation = each.value.collation
}

data "google_secret_manager_secret_version" "admin_password" {
  for_each = length(var.admin_user_password_secret) > 0 ? toset(["secret"]) : []

  secret  = var.admin_user_password_secret
  version = var.admin_user_password_secret_version
}

data "google_kms_secret" "admin_password" {
  for_each = length(var.admin_user_crypto_key) > 0 ? toset(["kms"]) : []

  crypto_key = var.admin_user_crypto_key
  ciphertext = var.admin_user_password_cipher
}

resource "google_sql_user" "admin_user_kms" {
  for_each = merge(
    { for key, value in data.google_kms_secret.admin_password : (var.admin_user) => value.plaintext },
    { for key, value in data.google_secret_manager_secret_version.admin_password : (var.admin_user) => value.secret_data }
  )

  instance = google_sql_database_instance.master.name
  name     = each.key
  password = each.value
}
