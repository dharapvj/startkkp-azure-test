
terraform {
  backend "azurerm" {
    resource_group_name  = "startkkp-tfstate"
    storage_account_name = "kkpstorageacct"
    container_name       = "tf-state-kkp-ypwzkwcjuxnw"
    key                  = "terraform-kkp.tfstate"
  }
}

