# Terraform configuration 
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.92.0"
      
    }
  }

# Configure the backend for storing Terraform state
backend "azurerm" {
  resource_group_name  = "terraformstate"
  storage_account_name = "terraformstate6177"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}



