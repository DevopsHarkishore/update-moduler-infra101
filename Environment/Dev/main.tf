module "resource_group" {
  source = "../../Module/azurerm_resource_group"

  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "virtual_network" {
  depends_on              = [module.resource_group]
  source                  = "../../Module/azurerm_virtual_network"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  virtual_network_name    = var.virtual_network_name
  address_space           = var.address_space
}

module "frontend_nsg" {
  depends_on = [module.resource_group, module.frontend_subnet]
  source     = "../../Module/azurerm_network_security_group"

  resource_group_name     = var.resource_group_name
  nsg_name                = var.frontend_nsg_name
  resource_group_location = var.resource_group_location
  subnet_name             = var.frontend_subnet_name
  virtual_network_name    = var.virtual_network_name
}

module "backend_nsg" {
  depends_on = [module.resource_group, module.backend_subnet]
  source     = "../../Module/azurerm_network_security_group"

  resource_group_name     = var.resource_group_name
  nsg_name                = var.backend_nsg_name
  resource_group_location = var.resource_group_location
  subnet_name             = var.backend_subnet_name
  virtual_network_name    = var.virtual_network_name
}

module "frontend_subnet" {
  depends_on           = [module.virtual_network, ]
  source               = "../../Module/azurerm_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.frontend_subnet_name
  address_prefixes     = var.frontend_address_prefixes
}

module "backend_subnet" {
  depends_on           = [module.virtual_network, ]
  source               = "../../Module/azurerm_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.backend_subnet_name
  address_prefixes     = var.backend_address_prefixes
}

module "bastion_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../../Module/azurerm_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.bastion_subnet_name
  address_prefixes     = var.bastion_address_prefixes
}

module "bastion_host" {
  depends_on           = [module.resource_group, module.virtual_network, module.bastion_subnet, module.bastion_public_ip]
  source               = "../../Module/azurerm_bastion"
  bastion_name         = var.bastion_name
  location             = var.bastion_location
  resource_group_name  = var.resource_group_name
  public_ip_name       = var.bastion_pip_name
  subnet_name          = var.bastion_subnet_name
  virtual_network_name = var.virtual_network_name
}
module "bastion_public_ip" {
  depends_on              = [module.frontend_subnet]
  source                  = "../../Module/azurerm_public_ip"
  public_ip_name          = var.bastion_pip_name
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "frontend_public_ip" {
  depends_on              = [module.frontend_subnet]
  source                  = "../../Module/azurerm_public_ip"
  public_ip_name          = var.lb_pip_name
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location

}
module "backend_public_ip" {
  depends_on              = [module.backend_subnet]
  source                  = "../../Module/azurerm_public_ip"
  public_ip_name          = var.backend_pip_name
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "frontend_vm" {
  depends_on           = [module.frontend_subnet, module.key_vault_secret, module.key_vault, module.resource_group, module.vm_username, module.vm_password]
  source               = "../../Module/azurerm_linux_virtual_machine"
  virtual_machine_name = var.frontend_vm_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.frontend_subnet_name
  # public_ip_name          = var.frontend_pip_name
  resource_group_location = var.resource_group_location
  network_interface_name  = var.frontend_nic_name
  virtual_machine_size    = var.frontend_vm_size
  username_secret_name    = var.vm_username
  password_secret_name    = var.vm_password
  key_vault_name          = var.kv_name
}

module "backend_vm" {
  depends_on           = [module.frontend_subnet, module.key_vault, module.vm_username, module.vm_password, module.resource_group]
  source               = "../../Module/azurerm_linux_virtual_machine"
  resource_group_name  = var.resource_group_name
  virtual_machine_name = var.backend_vm_name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.backend_subnet_name
  # public_ip_name          = "pip-dev-backend"
  virtual_machine_size    = var.backend_vm_size
  network_interface_name  = var.backend_nic_name
  resource_group_location = var.resource_group_location
  username_secret_name    = var.vm_username
  password_secret_name    = var.vm_password
  key_vault_name          = var.kv_name
}

module "lb" {
  source              = "../../Module/azurerm_loadbalancer"
  depends_on          = [module.resource_group, module.frontend_public_ip]
  resource_group_name = var.resource_group_name
}

module "nic_association_vm1" {
  depends_on             = [module.resource_group, module.lb, module.frontend_vm]
  source                 = "../../Module/azurerm_nic_lb_association"
  network_interface_name = var.frontend_nic_name
  resource_group_name    = var.resource_group_name
  lb_name                = var.lb_name
  backendpool_name       = var.backendpool_name
  ip_configuration_name  = var.ip_configuration_name
}

module "nic_association_vm2" {
  depends_on             = [module.resource_group, module.lb, module.backend_vm]
  source                 = "../../Module/azurerm_nic_lb_association"
  network_interface_name = var.backend_nic_name
  resource_group_name    = var.resource_group_name
  lb_name                = var.lb_name
  backendpool_name       = var.backendpool_name
  ip_configuration_name  = var.ip_configuration_name
}

module "key_vault" {
  depends_on              = [module.resource_group]
  source                  = "../../Module/azurerm_key_vault"
  key_vault_name          = var.kv_name
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "key_vault_secret" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = var.kv_name
  resource_group_name = var.resource_group_name
  secret_name         = var.kv_secret_name
  secret_value        = var.kv_secret_value
}

module "vm_username" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = var.kv_name
  resource_group_name = var.resource_group_name
  secret_name         = var.vm_username_secret_name
  secret_value        = var.vm_username_secret_value
}

module "vm_password" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = var.kv_name
  resource_group_name = var.resource_group_name
  secret_name         = var.vm_password_secret_name
  secret_value        = var.vm_password_secret_value
}

module "storage_account" {
  depends_on = [module.resource_group]
  source     = "../../Module/azurerm_storage_account"

  storage_account_name = var.storage_account_name

  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "container" {
  source                = "../../Module/azurerm_container"
  depends_on            = [module.storage_account]
  storage_account_name  = var.storage_account_name
  resource_group_name   = var.resource_group_name
  container_name        = var.container_name
  container_access_type = var.container_access_type
}

module "sqlserver_username" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = var.kv_name
  resource_group_name = var.resource_group_name
  secret_name         = var.sqlserver_username_secret_name
  secret_value        = var.sqlserver_username_secret_value
}

module "sqlserver_password" {
  depends_on          = [module.key_vault]
  source              = "../../Module/azurerm_key_vault_secret"
  key_vault_name      = var.kv_name
  resource_group_name = var.resource_group_name
  secret_name         = var.sqlserver_password_secret_name
  secret_value        = var.sqlserver_password_secret_value
}

module "mssql_server" {
  depends_on           = [module.resource_group, module.key_vault_secret, module.key_vault, module.sqlserver_username, module.sqlserver_password]
  source               = "../../Module/azurerm_mssql_server"
  resource_group_name  = var.resource_group_name
  mssqlserver_name     = var.mssqlserver_name
  mssqlserver_location = var.mssqlserver_location
  username_secret_name = var.mssql_password_secret_name
  password_secret_name = var.mssql_password_secret_name
  key_vault_name       = var.kv_name
}

module "mssql_database" {
  depends_on          = [module.mssql_server]
  source              = "../../Module/azurerm_mssql_database"
  resource_group_name = var.resource_group_name
  server_name         = var.mssqlserver_name
  database_name       = var.database_name
}




