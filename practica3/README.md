# Práctica 3 — Terraform 4

Infraestructura del diagrama del proyecto integrador. Un proyecto y estado único permiten revisar todas las dependencias en un plan. El grupo `rg-utvt-tf4-dev-001` es independiente de los laboratorios anteriores.

## Componentes

| Archivo | Recursos |
| --- | --- |
| versions.tf | Terraform >= 1.13 y AzureRM 5.0.0 |
| network.tf | VNet 10.0.0.0/16, cinco subredes y NSG |
| data.tf | PostgreSQL 16 B1ms, BD integradora, Blob LRS, endpoints y DNS privado |
| compute.tf | VM Ubuntu B2ats_v2, Bastion Basic, App Service Linux B1 e identidades |
| outputs.tf | Nombres, direcciones, IDs y SQL para habilitar los roles de la BD |

El endpoint PostgreSQL está en **10.0.2.4** y Blob en **10.0.4.4**, como en el PDF. La subred app está delegada a Microsoft.Web/serverFarms. PostgreSQL usa Private Link, no una subred delegada a PostgreSQL. La VM tiene IP 10.0.3.4 y carece de IP pública. Bastion tiene su propia IP pública. Los servicios PostgreSQL y Storage tienen acceso público deshabilitado; el frontend web admite HTTPS público según el diagrama.

## Preparación en PowerShell

Ya se generó un par RSA exclusivo en `.local/worker_rsa` y `.local/worker_rsa.pub`. Para esta sesión usa `& .\Preparar.ps1` y después `terraform plan -out=".local/practica3.tfplan"`. Conserva la clave privada: será necesaria para acceder por Bastion. El bloque siguiente describe la preparación general con un par propio.

```powershell
Set-Location 'C:\Users\luis1\Documents\PWA\Laboratorio\Terraform\practica3'
az login
$env:TF_VAR_subscription_id = az account show --query id -o tsv
$env:TF_VAR_entra_admin_object_id = az ad signed-in-user show --query id -o tsv
$env:TF_VAR_entra_admin_name = az ad signed-in-user show --query userPrincipalName -o tsv
# Usa la clave pública de un par SSH que controles. Conserva la privada fuera del repo.
$env:TF_VAR_ssh_public_key = Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub" -Raw
terraform init
terraform fmt -check
terraform validate
terraform plan -out=practica3.tfplan
```

Si utilizas otro nombre/región/tamaño, copia `terraform.tfvars.example` a `terraform.tfvars`, rellena los campos y evita duplicar valores distintos en variables de entorno. No se incluyen contraseñas. El administrador Entra debe pertenecer al tenant de la suscripción.

El provider tiene registro automático deshabilitado: antes del plan deben estar registrados Microsoft.Network, Microsoft.Compute, Microsoft.Web, Microsoft.Storage y Microsoft.DBforPostgreSQL. La cuenta necesita permisos para crear recursos y asignar roles (por ejemplo Contributor más Role Based Access Control Administrator). Si faltan proveedores o permisos, resolverlos explícitamente; no ocultar el fallo.

## Aplicación y verificación

Revisa el plan antes de ejecutar `terraform apply practica3.tfplan`. Bastion Basic, la VM, PostgreSQL y el plan B1 generan cargos. La disponibilidad del tamaño B2ats_v2, las cuotas, políticas y saldo de la suscripción se comprueban en Azure; validate no comprueba estos puntos.

1. Capturar `terraform init`, `validate`, `plan` y el resultado real de `apply`.
2. Revisar recursos y cinco subredes en el portal; ambos endpoints deben estar aprobados.
3. Entrar a la VM desde Bastion usando azureadmin y la clave privada del par SSH.
4. Desde la VM comprobar con `getent hosts` que PostgreSQL resuelve a 10.0.2.4 y Blob a 10.0.4.4; probar TCP 5432 y 443.
5. Ejecutar el SQL de `terraform output -raw postgres_identity_bootstrap` como administrador Entra, primero en postgres y luego en integradora. Las identidades no adquieren acceso SQL solo por tener Azure RBAC. El SQL crea roles la primera vez; antes de repetirlo revisar los roles existentes.
6. Publicar el código de la aplicación y utilizar tokens Entra para PostgreSQL y DefaultAzureCredential para Blob. Obtener un token PostgreSQL para el recurso `https://ossrdbms-aad.database.windows.net`; las variables de App Service contienen host y usuario, no generan el token. El worker debe usar el rol worker_integrador.
7. Crear un contenedor privado mediante la identidad autorizada desde la VM o aplicación; se deja para la comprobación del plano de datos, dado que Storage no admite acceso público ni claves compartidas.
8. Documentar por separado aprovisionamiento, resolución DNS, acceso a datos y publicación de aplicación. El código de esta práctica prepara infraestructura; no incluye la lógica del proyecto integrador ni procesa jobs.

Los NSG permiten PostgreSQL 5432 y Blob 443 desde app/VM, y SSH 22 a la VM desde Bastion. Otras entradas a esas subredes están bloqueadas. La salida conserva las reglas predeterminadas para resolver DNS y acceder a servicios de Azure. La VM no tiene NAT/IP pública de salida dedicada: instalar paquetes u otras conexiones públicas desde ella requiere diseñar explícitamente salida si la suscripción no ofrece acceso saliente predeterminado.

## Evidencias y entrega

Guardar capturas reales del despliegue en una carpeta local `evidencias`. El Word debe documentar objetivo, arquitectura, archivos, comandos, resultados y errores reales. Las capturas de Azure Lab 2 del 16 de octubre corresponden a otra ejecución manual y no acreditan un apply de esta práctica.

Para Git, agregar únicamente los archivos de practica3; no agregar el árbol completo porque existen cambios previos de otros laboratorios. El archivo `.terraform.lock.hcl` generado debe versionarse mediante `git add -f practica3/.terraform.lock.hcl`, porque el ignore del repositorio padre actualmente lo excluye. Nunca versionar estados, tfvars privados, planes o claves SSH.

Para eliminar exclusivamente esta infraestructura al terminar: revisar `terraform plan -destroy` y ejecutar `terraform destroy` solo tras confirmar los recursos del estado. Detener una VM no elimina cargos de discos, Bastion o App Service.

## Referencias

- Consigna y diagrama: 14. Terraform - 4 - Classroom.pdf, Jorge Almeida Montiel.
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server
- https://learn.microsoft.com/azure/postgresql/security/security-manage-entra-users

## Estado de validación

Consultar VALIDACION.md para los resultados locales. No se debe interpretar la validación estática como despliegue terminado.

