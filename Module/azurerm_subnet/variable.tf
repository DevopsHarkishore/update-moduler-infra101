variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}
variable "address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
}

# variable "nsg_name" {
#   description = "The name of the network security group to associate with the subnet."
#   type        = string
# }

