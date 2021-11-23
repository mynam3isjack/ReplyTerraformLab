provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "azurerm_resource_group" "terraform_rg" {
  name     = "${var.name}-terraform-resources"
  location = var.location
  
  tags = {
    application = "TerraformLab1"
    environment = var.environment
    name        = "Terraform Lab Resource Group"
  }
}

