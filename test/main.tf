locals {
  owner       = "myself"
  project     = var.project
  region      = "global"
  environment = var.environment

  terratest_key_ring   = "terratest"
  terratest_crypto_key = "cloudsql-master-password"

  vpc = {
    network_name = "private-cloudsql"
    subnets = {
      "cloudsql" = {
        ip_cidr_range = "10.10.0.0/25"
        region        = "europe-west1"
      }
    }
    service_networking_connection = {
      "google-managed-services-cloudsql" = {
        private_ip_address = {
          purpose       = "VPC_PEERING"
          prefix_length = 24
          address_type  = "INTERNAL"
        }
      }
    }
  }
}

module "vpc" {
  source  = "binxio/network-vpc/google"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  network_name                  = local.vpc.network_name
  subnets                       = local.vpc.subnets
  service_networking_connection = local.vpc.service_networking_connection
}

module "terratest_key_ring" {
  source  = "binxio/kms/google//modules/key_ring"
  version = "~> 1.0.0"

  project     = local.project
  environment = local.environment

  name = local.terratest_key_ring
}

module "terratest_crypto_key" {
  source  = "binxio/kms/google//modules/crypto_key"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  name     = local.terratest_crypto_key
  key_ring = module.terratest_key_ring.key_ring
}

resource google_kms_secret_ciphertext "admin_user_password" {
  crypto_key = module.terratest_crypto_key.crypto_key
  plaintext  = "test_secret_password"
}
