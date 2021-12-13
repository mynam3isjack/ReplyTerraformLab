terraform {
  backend "azurerm_prod" {
    resource_group_name  = "replyTerraform_prod"
    storage_account_name = "sareplyterraform_prod"
    container_name       = "terraform-state_prod"
    key                  = "terraform_prod.tfstate"
  }
}

resource "azurerm_resource_group" "replyTerraform_prod_resource_group" {
  name     = "replyTerraform_prod_resource_group"
  location = "northcentralus"
}

# module "replyterraform" {
#   source = "./modules/replyterraform"
#   name                = "terraformlab"
#   location            = "northcentralus"
#   environment = "lab"					
# }