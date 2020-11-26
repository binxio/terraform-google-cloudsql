output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets" {
  value = module.vpc.map
}

output "vpc_vars" {
  value = local.vpc
}

output "crypto_key" {
  value = module.terratest_crypto_key.crypto_key
}

output "admin_user_password_cipher" {
  value = google_kms_secret_ciphertext.admin_user_password.ciphertext
}
