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
    name     = "${substr("${lower("rg-${var.prefix}-${var.env}-${var.location}")}", 0, 24)}"
    location = var.location
}

resource "azurerm_key_vault" "key_vault" {
    name                        = "${substr("${lower("kv${var.prefix}${var.env}${var.location}")}", 0, 24)}"
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

# resources for aa runbook run

resource "azurerm_key_vault_secret" "key_vault_resource_group_name" {
    name         = "resource-group-name"
    value        = "${substr("${lower("rg-${var.prefix}-${var.env}-${var.location}")}", 0, 24)}"
    key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_app_id" {
    name         = "app-id"
    value        = var.app_id
    key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_app_key" {
    name         = "app-key"
    value        = var.app_key
    key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_tenant_id" {
    name         = "tenant-id"
    value        = var.tenant_id
    key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vault_web_app_name" {
    name         = "web-app-name"
    value        = "${substr("${lower("as-${var.prefix}-${var.env}-${var.location}")}", 0, 60)}"
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

data "azurerm_key_vault_secret" "key_vault_resource_group_name" {
    depends_on = [
      azurerm_key_vault_secret.key_vault_resource_group_name
    ]
    name         = "resource-group-name"
    key_vault_id = azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "key_vault_app_id" {
    depends_on = [
      azurerm_key_vault_secret.key_vault_app_id
    ]
    name         = "app-id"
    key_vault_id = azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "key_vault_app_key" {
    depends_on = [
      azurerm_key_vault_secret.key_vault_app_key
    ]
    name         = "app-key"
    key_vault_id = azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "key_vault_tenant_id" {
    depends_on = [
      azurerm_key_vault_secret.key_vault_tenant_id
    ]
    name         = "tenant-id"
    key_vault_id = azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "key_vault_web_app_name" {
    depends_on = [
      azurerm_key_vault_secret.key_vault_web_app_name
    ]
    name         = "web-app-name"
    key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_automation_account" "automation_account" {
    name                = "${substr("${lower("aa-${var.prefix}-${var.env}-${var.location}")}", 0, 24)}"
    location            = azurerm_resource_group.resource_group.location
    resource_group_name = azurerm_resource_group.resource_group.name
    sku_name            = var.aa_sku_name

    tags = {
        environment = var.env
    }
}

# locals {
#     resource_group_name = "${substr("${lower("rg-${var.prefix}-${var.env}-${var.location}")}", 0, 24)}"
# }

resource "azurerm_automation_variable_string" "app_id" {
  name                    = "app_id"
  resource_group_name     = azurerm_resource_group.resource_group.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = data.azurerm_key_vault_secret.key_vault_app_id.value
}

resource "azurerm_automation_variable_string" "app_key" {
  name                    = "app_key"
  resource_group_name     = azurerm_resource_group.resource_group.name
  automation_account_name = azurerm_automation_account.automation_account.name
  encrypted               = true
  value                   = data.azurerm_key_vault_secret.key_vault_app_key.value
}

resource "azurerm_automation_variable_string" "tenant_id" {
  name                    = "tenant_id"
  resource_group_name     = azurerm_resource_group.resource_group.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = data.azurerm_key_vault_secret.key_vault_tenant_id.value
}

resource "azurerm_automation_variable_string" "rg_name" {
  name                    = "rg_name"
  resource_group_name     = azurerm_resource_group.resource_group.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = data.azurerm_key_vault_secret.key_vault_resource_group_name.value
}

resource "azurerm_automation_variable_string" "web_app_name" {
  name                    = "web_app_name"
  resource_group_name     = azurerm_resource_group.resource_group.name
  automation_account_name = azurerm_automation_account.automation_account.name
  value                   = data.azurerm_key_vault_secret.key_vault_web_app_name.value
}

data "local_file" "app_start" {
   filename = "${path.module}/script/app_start.ps1"
}

data "local_file" "app_stop" {
   filename = "${path.module}/script/app_stop.ps1"
}

resource "azurerm_automation_runbook" "aa_runbook_start" {
    depends_on = [
      azurerm_automation_account.automation_account
    ]
    name                    = "app_start"
    location                = azurerm_resource_group.resource_group.location
    resource_group_name     = azurerm_resource_group.resource_group.name
    automation_account_name = azurerm_automation_account.automation_account.name
    log_verbose             = "true"
    log_progress            = "true"
    description             = "start web app by schedule"
    runbook_type            = "PowerShell"

    content = data.local_file.app_start.content
}

resource "azurerm_automation_schedule" "automation_schedule_start" {
    depends_on = [
        azurerm_automation_account.automation_account
    ]
    name                    = "aa-automation-schedule-start"
    resource_group_name     = azurerm_resource_group.resource_group.name
    automation_account_name = azurerm_automation_account.automation_account.name
    frequency               = "Day"
    interval                = 1
    start_time              = "${substr(timeadd(timestamp(), "24h"), 0, 10)}T09:00:00+01:00"
    timezone                = "Europe/Kiev"
    description             = "start web app"
}

resource "azurerm_automation_job_schedule" "job_schedule_start" {
    depends_on = [
        azurerm_automation_account.automation_account,
        azurerm_automation_schedule.automation_schedule_start,
        azurerm_automation_runbook.aa_runbook_start
    ]
    count                   = (var.env == "dev" ? 1 : 0)
    resource_group_name     = azurerm_resource_group.resource_group.name
    automation_account_name = azurerm_automation_account.automation_account.name
    schedule_name           = azurerm_automation_schedule.automation_schedule_start.name
    runbook_name            = azurerm_automation_runbook.aa_runbook_start.name
}

resource "azurerm_automation_runbook" "aa_runbook_stop" {
    depends_on = [
      azurerm_automation_account.automation_account
    ]
    name                    = "app_stop"
    location                = azurerm_resource_group.resource_group.location
    resource_group_name     = azurerm_resource_group.resource_group.name
    automation_account_name = azurerm_automation_account.automation_account.name
    log_verbose             = "true"
    log_progress            = "true"
    description             = "stop web app by schedule"
    runbook_type            = "PowerShell"

    content = data.local_file.app_stop.content
}

resource "azurerm_automation_schedule" "automation_schedule_stop" {
    depends_on = [
        azurerm_automation_account.automation_account
    ]
    name                    = "aa-automation-schedule-stop"
    resource_group_name     = azurerm_resource_group.resource_group.name
    automation_account_name = azurerm_automation_account.automation_account.name
    frequency               = "Day"
    interval                = 1
    start_time              = "${substr(timeadd(timestamp(), "24h"), 0, 10)}T18:00:00+01:00"
    timezone                = "Europe/Kiev"
    description             = "stop web app"
}

resource "azurerm_automation_job_schedule" "job_schedule_stop" {
    depends_on = [
        azurerm_automation_account.automation_account,
        azurerm_automation_schedule.automation_schedule_stop,
        azurerm_automation_runbook.aa_runbook_stop
    ]
    count                   = (var.env == "dev" ? 1 : 0)
    resource_group_name     = azurerm_resource_group.resource_group.name
    automation_account_name = azurerm_automation_account.automation_account.name
    schedule_name           = azurerm_automation_schedule.automation_schedule_stop.name
    runbook_name            = azurerm_automation_runbook.aa_runbook_stop.name
}

resource "azurerm_service_plan" "service_plan" {
    name                         = "${substr("${lower("asp-${var.prefix}-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name          = azurerm_resource_group.resource_group.name
    location                     = azurerm_resource_group.resource_group.location
    sku_name                     = var.sku_name
    os_type                      = var.os_type

    tags = {
        env = var.env
    }
}

resource "azurerm_linux_web_app" "linux_web_app" {
    name                         = "${substr("${lower("as-${var.prefix}-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name          = azurerm_resource_group.resource_group.name
    location                     = azurerm_resource_group.resource_group.location
    service_plan_id              = azurerm_service_plan.service_plan.id

    site_config {
        always_on                = false #default variable
    }
}

resource "azurerm_virtual_network" "virtual_network" {
    name                = "${substr("${lower("vnet-${var.prefix}-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name = azurerm_resource_group.resource_group.name
    location            = azurerm_resource_group.resource_group.location
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal_subnet" {
    name                 = "${substr("${lower("snet-${var.prefix}-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name  = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.virtual_network.name
    address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "linux_virtual_machine_scale_set" {
    depends_on = [
        data.azurerm_key_vault_secret.key_vault_secret_vm_login, data.azurerm_key_vault_secret.key_vault_secret_vm_password
    ]
    name                            = "${substr("${lower("vmss-${var.prefix}-${var.env}-${var.location}")}", 0, 60)}"
    resource_group_name             = azurerm_resource_group.resource_group.name
    location                        = azurerm_resource_group.resource_group.location
    sku                             = var.lvmss_sku
    instances                       = 0
    admin_username                  = data.azurerm_key_vault_secret.key_vault_secret_vm_login.value
    admin_password                  = data.azurerm_key_vault_secret.key_vault_secret_vm_password.value
    disable_password_authentication = false
    source_image_id                  = var.shared_image

    os_disk {
        storage_account_type = var.os_disk_storage_account_type
        caching              = var.os_disk_caching
    }

    network_interface {
        name    = "${substr("${lower("nic-${var.prefix}-${var.env}-${var.location}")}", 0, 60)}"
        primary = true

        ip_configuration {
            name      = "internal"
            primary   = true
            subnet_id = azurerm_subnet.internal_subnet.id
        }
    }
}
