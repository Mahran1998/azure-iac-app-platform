provider "azurerm" {
  features {}

  # AzureRM v3.x: skip auto-registering all providers (avoids 409 conflicts)
  skip_provider_registration = true
}
