# Terraform Lab1
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}

  subscription_id = "7651bfc0-e571-4e44-927c-0f4c5edf3b14" # ahdil_maqsood@hotmail
  tenant_id       = "122b2e24-d07d-4741-b283-9cfe3f098c4c" # ahdil_maqsood@hotmail
}

module "replyterraform" {
  source = "./../modules/replyterraform"

  name                = "terraformlab"
  location            = "westeurope"

  environment         = "lab"
  
}