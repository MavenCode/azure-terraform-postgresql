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
}

resource "azurerm_postgresql_database" "sql_db" {
    name                            = var.sql_db_name
    resource_group_name             = var.resource_group_name
    server_name                     = azurerm_postgresql_server.sql_server.name
    charset                         = var.db_charset
    collation                       = var.db_collation
}