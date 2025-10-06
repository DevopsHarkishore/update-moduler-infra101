
variable "public_ip_name" {
  description = "The name of the public IP address."
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