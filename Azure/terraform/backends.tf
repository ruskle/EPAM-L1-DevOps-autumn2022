terraform {
    backend "azurerm" {
        key = "rg.tfstate"
    }
}