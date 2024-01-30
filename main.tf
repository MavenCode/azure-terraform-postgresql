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

resource "azurerm_postgresql_virtual_network_rule" "postgres_vnet_rule" {
  name                                 = var.sql_name
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.sql_server.name
  subnet_id                            = var.subnet_id
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

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_endpoint_name
    private_connection_resource_id = azurerm_postgresql_server.sql_server.id
    subresource_names              = [ "postgresqlServer" ]
    is_manual_connection           = false
  }

  ip_configuration {
    name                = var.private_endpoint_name
    private_ip_address  = var.postres_private_ip
    subresource_name    = "postgresqlServer"
    member_name         = "postgresqlServer"
  }

  depends_on = [
    azurerm_postgresql_server.sql_server
  ]
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = "${var.postgres_dns_name}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_private_endpoint.private_endpoint
  ]
}

resource "azurerm_dns_a_record" "dns_record" {
  name                = "postgres_private_record"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.time_to_live
  records             = [var.postres_private_ip]

  depends_on = [
    azurerm_dns_zone.dns_zone
  ]
}