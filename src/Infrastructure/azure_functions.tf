resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
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

  lifecycle {
    ignore_changes = [
      kind
    ]
  }
}

resource "azurerm_function_app" "functions" {
    name                      = var.function_app_name
    location                  = azurerm_resource_group.rg.location
    resource_group_name       = azurerm_resource_group.rg.name
    app_service_plan_id       = azurerm_app_service_plan.functions.id
    storage_account_name       = var.function_storage_name
    storage_account_access_key = azurerm_storage_account.functions.primary_access_key
    os_type                   = "linux"

    version                    = "~4"
 identity {
    type = "SystemAssigned"
  }

  app_settings = {
    https_only                     = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
    FUNCTION_APP_EDIT_MODE         = "readonly"
    storage_name                   = azurerm_storage_account.storage.name
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}