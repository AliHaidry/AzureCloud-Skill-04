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
    storage_account_access_key = var.function_storage_access_key.storage.primary_access_key
    # Remove the storage_connection_string attribute
    # storage_connection_string = azurerm_storage_account.functions.primary_connection_string
    os_type                   = "linux"

    version                    = "~4"

  site_config {
    linux_fx_version = "python|3.9"
  }
}
