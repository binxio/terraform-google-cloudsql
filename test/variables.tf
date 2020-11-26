variable "environment" {
  description = "Allows us to use random environment for our tests"
  type        = string
}

variable "project" {
  description = "Allows us to use random project for our tests"
  type        = string
}

variable "location" {
  description = "Allows us to use random location for our tests"
  type        = string
}

variable "owner" {
  description = "Owner used for tagging"
  type        = string
}

variable "subnet" {
  description = "The self_link output of created subnet for cloudsql"
  type        = string
}

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
