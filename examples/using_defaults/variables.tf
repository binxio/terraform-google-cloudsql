variable "network" {
  description = "The self_link output of created vpc for cloudsql"
  type        = string
}

variable "admin_user_crypto_key" {
  type    = string
  default = ""
}

variable "admin_user_password_cipher" {
  type    = string
  default = ""
}
