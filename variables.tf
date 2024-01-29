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

variable "existing_subnet" {}

variable "existing_subnet_id" {}

variable "new_subnet_id" {}

variable "private_endpoint_name" {}

variable "postres_private_ip" {}

variable "postgres_dns_name" {}

variable "time_to_live" {}