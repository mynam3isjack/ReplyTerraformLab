provider "azurerm" {
  version = "~> 2.65"
  features {}
  subscription_id = "475a2aea-10e5-4288-abc9-9efd4f3dc215" # jacopo.devecchis@outlook.com
  tenant_id = "2988608b-70b9-4911-9303-78aadfa95034" # jacopo.devecchis@outlook.com
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
  name     = "${var.name}-terraform-resources"
  location = "northcentralus"
}

module "replyterraform" {
  source = "./modules/replyterraform"
  name                = "terraformlab"
  location            = "northcentralus"
  environment = "lab"					
}