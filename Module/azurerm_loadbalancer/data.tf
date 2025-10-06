data "azurerm_public_ip" "pip" {
  name                = "loadbalancer_ip"
  resource_group_name = "rg-dev"
}
