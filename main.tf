resource "azurerm_resource_group" "lab" {
  name     = "lab-rg"
  location = "West US"
}

resource "azurerm_log_analytics_workspace" "lab" {
  name                = "lab-law"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "lab" {
  name                       = "lab-cae"
  location                   = azurerm_resource_group.lab.location
  resource_group_name        = azurerm_resource_group.lab.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab.id
}
resource "azurerm_container_app" "lab" {
  name                         = "lab-ca"
  container_app_environment_id = azurerm_container_app_environment.lab.id
  resource_group_name          = azurerm_resource_group.lab.name
  revision_mode                = "Single"

  template {
    container {
      name   = "labcontainerapp"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}