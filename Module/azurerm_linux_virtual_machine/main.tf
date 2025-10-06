
resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    # public_ip_address_id = data.azurerm_public_ip.public_ip.id
    name                 = "internal"
    subnet_id            = data.azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"
  }


}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                            = var.virtual_machine_name
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  size                            = var.virtual_machine_size
  admin_username                  = data.azurerm_key_vault_secret.vm-username.value
  admin_password                  = data.azurerm_key_vault_secret.vm-password.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
  #!/bin/bash
  apt-get update
  apt-get install -y nginx
  systemctl enable nginx
  systemctl start nginx
 EOF

  )
}

