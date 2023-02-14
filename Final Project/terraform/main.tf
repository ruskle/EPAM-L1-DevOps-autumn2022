data "azurerm_client_config" "current" {}
# block for local us terraform 
# data external account_info {
#     program                    = [
#                                  "az",
#                                  "ad",
#                                  "signed-in-user",
#                                  "show",
#                                  "--query",
#                                  "{object_id:id}",
#                                  "-o",
#                                  "json",
#                                  ]
# }

resource "azurerm_resource_group" "resource_group" {
    name     = "${substr("${lower("rg-epam-${var.env}-${var.location}")}", 0, 24)}"
    location = var.location
}

resource "azurerm_key_vault" "key_vault" {
    name                        = "${substr("${lower("kvepam${var.env}${var.location}")}", 0, 24)}"
    location                    = azurerm_resource_group.resource_group.location
    resource_group_name         = azurerm_resource_group.resource_group.name
    enabled_for_disk_encryption = true
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false

    sku_name = "standard"

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        # object_id = data.external.account_info.result.object_id  # block for local us terraform 
        object_id = data.azurerm_client_config.current.object_id

        key_permissions = [
            "Create",
            "Get",
            "Purge",
            "Recover"
        ]

        secret_permissions = [
            "Set",
            "Get",
            "Delete",
            "Purge",
            "Recover"
        ]

        storage_permissions = [
            "Get",
        ]
    }
}

resource "azurerm_key_vault_secret" "key_vault_secret_vm_login" {
    name         = "vm-login"
    value        = "final_project_admin"
    key_vault_id = azurerm_key_vault.key_vault.id
}


resource "azurerm_key_vault_secret" "key_vault_secret_vm_password" {
    name         = "vm-password"
    value        = var.vm_password
    key_vault_id = azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "key_vault_secret_vm_login" {
    depends_on = [
      azurerm_key_vault_secret.key_vault_secret_vm_login
    ]
    name         = "vm-login"
    key_vault_id = azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "key_vault_secret_vm_password" {
    depends_on = [
      azurerm_key_vault_secret.key_vault_secret_vm_password
    ]
    name         = "vm-password"
    key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_automation_account" "automation_account" {
    name                = "${substr("${lower("aa-epam-${var.env}-${var.location}")}", 0, 24)}"
    location            = azurerm_resource_group.resource_group.location
    resource_group_name = azurerm_resource_group.resource_group.name
    sku_name            = var.aa_sku_name

    tags = {
        environment = var.env
    }
}

resource "azurerm_service_plan" "service_plan" {
    name                         = "${substr("${lower("asp-epam-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name          = azurerm_resource_group.resource_group.name
    location                     = azurerm_resource_group.resource_group.location
    sku_name                     = var.sku_name
    os_type                      = var.os_type

    tags = {
        env = var.env
    }
}

resource "azurerm_linux_web_app" "linux_web_app" {
    name                         = "${substr("${lower("as-epam-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name          = azurerm_resource_group.resource_group.name
    location                     = azurerm_resource_group.resource_group.location
    service_plan_id              = azurerm_service_plan.service_plan.id

    site_config {
        always_on                = false #default variable
    }
}

resource "azurerm_virtual_network" "virtual_network" {
    name                = "${substr("${lower("vnet-epam-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name = azurerm_resource_group.resource_group.name
    location            = azurerm_resource_group.resource_group.location
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal_subnet" {
    name                 = "${substr("${lower("snet-epam-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name  = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.virtual_network.name
    address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "linux_virtual_machine_scale_set" {
    depends_on = [
        data.azurerm_key_vault_secret.key_vault_secret_vm_login, data.azurerm_key_vault_secret.key_vault_secret_vm_password
    ]
    name                            = "${substr("${lower("vmss-epam-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name             = azurerm_resource_group.resource_group.name
    location                        = azurerm_resource_group.resource_group.location
    sku                             = var.lvmss_sku
    instances                       = 1
    admin_username                  = data.azurerm_key_vault_secret.key_vault_secret_vm_login.value
    admin_password                  = data.azurerm_key_vault_secret.key_vault_secret_vm_password.value
    disable_password_authentication = false
    source_image_id                  = var.shared_image

    os_disk {
        storage_account_type = var.os_disk_storage_account_type
        caching              = var.os_disk_caching
    }

    network_interface {
        name    = "${substr("${lower("nic-epam-${var.env}-${var.location}")}", 0, 60)}"
        primary = true

        ip_configuration {
            name      = "internal"
            primary   = true
            subnet_id = azurerm_subnet.internal_subnet.id
        }
    }
}
