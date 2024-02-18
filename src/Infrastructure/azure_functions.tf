resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_application_insights" "functions" {
  name                = var.function_app_insights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_storage_account" "functions" {
  name                     = var.function_storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "functions" {
  name                = var.function_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "functions" {
    name                      = var.function_app_name
    location                  = azurerm_resource_group.rg.location
    resource_group_name       = azurerm_resource_group.rg.name
    app_service_plan_id       = azurerm_app_service_plan.functions.id
    storage_account_name       = azurerm_storage_account.storage.name
    storage_account_access_key = azurerm_storage_account.storage.primary_access_key
    # Remove the storage_connection_string attribute
    # storage_connection_string = azurerm_storage_account.functions.primary_connection_string
    os_type                   = "linux"

    version                    = "~4"

  site_config {
    linux_fx_version = "python|3.9"
  }

    identity {
        type = "SystemAssigned"
    }

    app_settings = {
        https_only                     = true
        FUNCTIONS_WORKER_RUNTIME       = "python"
        FUNCTION_APP_EDIT_MODE         = "readonly"
        APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.functions.instrumentation_key
        storage_name                   = azurerm_storage_account.storage.name
        storage_account_access_key     = azurerm_storage_account.storage.primary_access_key
        storage_account_name           = azurerm_storage_account.storage.name
    }
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}