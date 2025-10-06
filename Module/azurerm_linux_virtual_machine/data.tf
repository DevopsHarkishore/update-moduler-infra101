# data "azurerm_public_ip" "public_ip" {
#   name                = var.public_ip_name
#   resource_group_name = var.resource_group_name
# }
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}


data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}


data "azurerm_key_vault_secret" "vm-username" {
  name         = var.username_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
data "azurerm_key_vault_secret" "vm-password" {
  name         = var.password_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
