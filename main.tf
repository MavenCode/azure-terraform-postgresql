data "azurerm_virtual_network" "existing_postgres_vnet" {
  count                 = var.vnet_exists ? 1 : 0
  name                  = var.postgres_vnet_name
  resource_group_name   = var.resource_group_name
}

data "azurerm_subnet" "existing_postgres_subnet" {
  count                 = var.vnet_exists ? 1 : 0
  name                  = var.postgres_subnet_name
  virtual_network_name  = var.postgres_vnet_name
  resource_group_name   = var.resource_group_name
}

locals {
  vnet_exists = length(data.azurerm_virtual_network.existing_postgres_vnet) > 0
}

resource "azurerm_virtual_network" "postgres_vnet" {
  count               = local.vnet_exists ? 0 : 1
  name                = var.postgres_vnet_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_range
}

resource "azurerm_subnet" "postgres_subnet" {
  count                = local.vnet_exists ? 0 : 1
  name                 = var.postgres_subnet_name
  virtual_network_name = var.postgres_vnet_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.subnet_address_range
  service_endpoints    = ["Microsoft.Sql"]

  depends_on = [
    azurerm_virtual_network.postgres_vnet
  ]
}

resource "azurerm_postgresql_server" "sql_server" {
    name                            = var.sql_name
    location                        = var.resource_group_location
    resource_group_name             = var.resource_group_name

    sku_name                        = var.sku_name

    storage_mb                      = var.storage_mb
    backup_retention_days           = var.backup_retention_days
    geo_redundant_backup_enabled    = var.geo_redundant_backup_enabled
    auto_grow_enabled               = var.auto_grow_enabled

    administrator_login             = var.admin_login
    administrator_login_password    = var.administrator_login_password
    version                         = var.server_version
    ssl_enforcement_enabled         = var.ssl_enforcement_enabled
    public_network_access_enabled   = var.public_network_access_enabled

    depends_on = [
      azurerm_subnet.postgres_subnet
    ]
}

resource "azurerm_postgresql_virtual_network_rule" "postgres_vnet_rule" {
  name                                 = var.sql_name
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.sql_server.name
  subnet_id                            = local.vnet_exists ? data.azurerm_subnet.existing_postgres_subnet[0].id : azurerm_subnet.postgres_subnet[0].id
  ignore_missing_vnet_service_endpoint = true

  depends_on = [
    azurerm_postgresql_server.sql_server
  ]
}

resource "azurerm_postgresql_database" "sql_db" {
    name                            = var.sql_db_name
    resource_group_name             = var.resource_group_name
    server_name                     = azurerm_postgresql_server.sql_server.name
    charset                         = var.db_charset
    collation                       = var.db_collation

    depends_on = [
      azurerm_postgresql_server.sql_server
    ]
}