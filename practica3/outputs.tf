output "resource_group_name" { value = azurerm_resource_group.lab.name }
output "web_url" { value = "https://${azurerm_linux_web_app.lab.default_hostname}" }
output "postgres_host" { value = azurerm_postgresql_flexible_server.lab.fqdn }
output "storage_account_name" { value = azurerm_storage_account.lab.name }
output "worker_private_ip" { value = azurerm_network_interface.worker.private_ip_address }
output "app_principal_id" { value = azurerm_linux_web_app.lab.identity[0].principal_id }
output "worker_principal_id" { value = azurerm_linux_virtual_machine.worker.identity[0].principal_id }
output "private_endpoint_ips" { value = { for k, v in local.endpoints : k => v.ip } }
output "postgres_identity_bootstrap" {
  description = "SQL a ejecutar como administrador Entra en postgres y luego integradora desde la red privada."
  value       = <<-SQL
    -- Conectar a postgres como administrador Entra:
    SELECT * FROM pgaadauth_create_principal_with_oid('app_integrador', '${azurerm_linux_web_app.lab.identity[0].principal_id}', 'service', false, false);
    SELECT * FROM pgaadauth_create_principal_with_oid('worker_integrador', '${azurerm_linux_virtual_machine.worker.identity[0].principal_id}', 'service', false, false);
    GRANT CONNECT ON DATABASE integradora TO app_integrador, worker_integrador;
    -- Reconectar a integradora como administrador Entra:
    GRANT USAGE, CREATE ON SCHEMA public TO app_integrador, worker_integrador;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_integrador, worker_integrador;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_integrador, worker_integrador;
    -- Ejecutar por cada rol propietario de futuras tablas:
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_integrador, worker_integrador;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO app_integrador, worker_integrador;
  SQL
}
