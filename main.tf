provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "replyTerraformLab"
    storage_account_name = "sareplyterraformlab"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "replyTerraformLab_resource_group" {
  name     = "replyTerraformLab_resource_group"
  location = "northcentralus"
}

# module "replyterraform" {
#   source = "./modules/replyterraform"
#   name                = "terraformlab"
#   location            = "northcentralus"
#   environment = "lab"					
# }