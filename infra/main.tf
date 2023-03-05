####################################################################################################
# Terraform configuration
terraform {

  ##################################################
  # Required Terraform version
  required_version = ">= 1.3.0, < 2.0.0"

  ##################################################
  # Required providers
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  ##################################################
  # Backend
  /*backend "azurerm" {
    resource_group_name  = "prrgazpro05"
    storage_account_name = "prstraccazpro05"
    container_name       = "prcontazpro05"
    key                  = "aztfpro05"
  }*/
}

####################################################################################################
# Provider configuration
provider "azurerm" {
  /*
  tenant_id       = var.ARM_TENANT_ID
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  */
  features {}
}
