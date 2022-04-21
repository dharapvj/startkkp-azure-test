terraform {
  backend "azurerm" {
    resource_group_name  = "startkkp-tfstate"
    storage_account_name = "kkpstorageacct"
    container_name       = "tf-state-kkp-nfodh7wt41kq"
    key                  = "terraform-kkp.tfstate"
  }
}
