variable "sql_name" {}
variable "resource_group_location" {}
variable "resource_group_name" {}
variable "sku_name" {}
variable "storage_mb" {}
variable "geo_redundant_backup_enabled" {}
variable "auto_grow_enabled" {}
variable "backup_retention_days" {}

variable "admin_login" {}
variable "administrator_login_password" {}
variable "server_version" {}
variable "ssl_enforcement_enabled" {}
variable "public_network_access_enabled" {}

variable "sql_db_name" {}
variable "db_charset" {}
variable "db_collation" {}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# virtual network and subnet
variable "postgres_vnet_name" {}
variable "postgres_subnet_name" {}

variable "vnet_address_range" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "subnet_address_range" {
  description = "The address prefixes for the subnet"
  type        = list(string)
}

variable "vnet_exists" {}