output "resource_group_id" {
    value = azurerm_resource_group.resource_group.id
}

output "automation_account_id" {
    value = azurerm_automation_account.automation_account.id
}

output "key_vault_id" {
    value = azurerm_key_vault.key_vault.id
}

output "service_plan_id" {
    value = azurerm_service_plan.service_plan.id
}

output "linux_web_app_id" {
    value = azurerm_linux_web_app.linux_web_app.id
}

output "linux_virtual_machine_scale_set_id" {
    value = azurerm_linux_virtual_machine_scale_set.linux_virtual_machine_scale_set.id
} 