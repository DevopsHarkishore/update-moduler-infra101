
resource "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  location            = "West Europe"
  resource_group_name = "rg-dev"

  frontend_ip_configuration {
    name                 = "NetflixPublicIPAddress"
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}
resource "azurerm_lb_backend_address_pool" "pool1" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "lb_BackEndAddressPool1"
}
resource "azurerm_lb_probe" "probe1" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "netflix-probe"
  port            = 80
}
# IP and Port based Routing
resource "azurerm_lb_rule" "lb_rule1" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "NetflixRule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "NetflixPublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool1.id]
  probe_id                       = azurerm_lb_probe.probe1.id
}
