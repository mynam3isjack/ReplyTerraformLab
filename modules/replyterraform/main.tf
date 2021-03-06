provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "azurerm_resource_group" "replyTerraformLab_resource_group" {
  name     = "${var.name}-terraform-resources"
  location = var.location
}

