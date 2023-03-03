variable "location" {
    default = "West Europe"
    type = string
    description = "location name"
}

variable "env" {
    default = "dev"
    type = string
    description = "env name"
}

variable "sku_name" {
    default = "F1"
    type = string
    description = "sp sku name"
}

variable "os_type" {
    default = "Linux"
    type = string
    description = "os type"
}

variable "vm_password" {
    type = string
    description = "vm password"
}

variable "tenant_id" {
    type = string
    default = "f471ca54-cd7b-4c59-82cd-0caf5631aee7"
    description = "id of tennant"
}

variable "aa_sku_name" {
    default = "Free"
    type = string
    description = "automation account sku_name"
}

variable "lvmss_sku" {
    default = "Standard_B2s"
    type = string
    description = "lvmss sku"
}

variable "lvmss_source_image_offer" {
    default = "UbuntuServer"
    type = string
    description = "lvmss source_image_reference offer"
}

variable "lvmss_source_image_sku" {
    default = "18.04-LTS"
    type = string
    description = "lvmss source_image_reference sku"
}

variable "lvmss_source_image_version" {
    default = "latest"
    type = string
    description = "lvmss source_image_reference version"
}

variable "lvmss_source_image_publisher" {
    default = "Canonical"
    type = string
    description = "lvmss source_image_reference publisher"
}

variable "os_disk_storage_account_type" {
    default = "Standard_LRS"
    type = string
    description = "os disk storage account type"
}

variable "os_disk_caching" {
    default = "ReadWrite"
    type = string
    description = "os disk caching"
}

variable "shared_image" {
    default = "/subscriptions/3b789e5a-d874-493c-926e-c49708d38c82/resourceGroups/rg-epam-com-westeurope/providers/Microsoft.Compute/galleries/gal_epam_com_westeurope/images/ubuntu-20.04-build-agent/versions/0.25579.15020"
    type = string
    description = "shared_image"
}

variable "app_key" {
    type = string
    description = "app_key"
}

variable "app_id" {
    type = string
    description = "app_id"
}

variable "rg_name" {
    type = string
    description = "resource group name"
}

variable "prefix" {
    default = "epam"
    type = string
    description = "prefix"
}
