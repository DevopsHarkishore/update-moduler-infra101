terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "harkishore"
    tenant_id            = "72078cd2-d503-4251-91da-b215f1e1bc36"
    storage_account_name = "infrastorage121"
    container_name       = "infracontainer"
    key                  = "lb2-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "d73ab938-2a60-42e2-87cd-9362d4e73029"
}