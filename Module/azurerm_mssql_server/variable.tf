
variable "mssqlserver_name" {
  description = "The name of the SQL server."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
variable "mssqlserver_location" {
  description = "The location of the resource group."
  type        = string
  default     = "West Europe"
}

variable "key_vault_name" {
  description = "The name of the Key Vault where secrets are stored."
  type        = string
}
variable "username_secret_name" {
  description = "The name of the secret in Key Vault for the SQL server administrator username."
  type        = string
}

variable "password_secret_name" {
  description = "The name of the secret in Key Vault for the SQL server administrator password."
  type        = string
}