# variable "public_ip_name" {
#   description = "The name of the public IP address."
#   type        = string
  
# }
variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}
variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "network_interface_name" {
  description = "The name of the network interface."  
  type        = string
}
variable "virtual_machine_name" {
  description = "The name of the virtual machine."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
  default     = "West Europe"
}
variable "virtual_machine_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_B1s"
}
variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
  
}

variable "username_secret_name" {
  description = "The administrator username for the virtual machine."
  type        = string
}
variable "password_secret_name" {
  description = "The administrator password for the virtual machine."
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "The ID of the subnet."
  type        = string
  default     = ""
}
