output "server_name" {
  value       = azurerm_postgresql_server.sql_server.name
}

output "server_fqdn" {
  value       = azurerm_postgresql_server.sql_server.fqdn
}

output "server_id" {
  value       = azurerm_postgresql_server.sql_server.id
}

output "database_ids" {
  value       = [azurerm_postgresql_database.sql_db.*.id]
}