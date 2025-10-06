resource "azurerm_mssql_server" "mssqlserver_name" {
  name                         = var.mssqlserver_name
  resource_group_name          = var.resource_group_name
  location                     = var.mssqlserver_location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.sqlserver-username.value
  administrator_login_password = data.azurerm_key_vault_secret.sqlserver-password.value
  minimum_tls_version          = "1.2"
 public_network_access_enabled = false
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}


data "azurerm_key_vault_secret" "sqlserver-username" {
  name         = var.username_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
data "azurerm_key_vault_secret" "sqlserver-password" {
  name         = var.password_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}


