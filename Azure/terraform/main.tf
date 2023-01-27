# Create the App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${substr("${lower("asp01-${var.project_name}-${var.env}-${var.location}")}", 0, 60)}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
  sku_name            = "F1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_windows_web_app" "webapp" {
  name                = "${substr("${lower("webapp01-${var.project_name}-${var.env}-${var.location}")}", 0, 60)}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config {
    always_on = false
  }
}
