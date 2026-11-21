# Terraform · Laboratorios IDGS-103

Prácticas de **infraestructura como código con Terraform sobre Microsoft Azure**, de la materia IDGS-103 (Universidad Tecnológica del Valle de Toluca). Van de los primeros recursos a un despliegue completo con red, base de datos, almacenamiento y cómputo.

![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A51.13-7B42BC?logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-azurerm%205.0-0078D4?logo=microsoftazure&logoColor=white)

## Contenido

### `Practica1/` — Fundamentos
Primeros recursos y organización del código en módulos (`main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`):

| Laboratorio | Qué despliega |
| --- | --- |
| Laboratorio1 | Resource group y red virtual (VNet) |
| Laboratorio2 | Resource group y VNet con variables y `locals` |
| Laboratorio3 | App Service (Linux) con Log Analytics y Application Insights |

### `practica3/` — Proyecto integrador
Infraestructura completa en un solo estado: VNet con subredes y NSG, PostgreSQL 16 con Private Link, Azure Blob Storage, VM Ubuntu, Azure Bastion y App Service. Incluye su propia documentación: **[practica3/README.md](practica3/README.md)** y **[practica3/VALIDACION.md](practica3/VALIDACION.md)**.

## Requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.13
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) con sesión iniciada (`az login`)
- Una suscripción de Azure propia

## Uso

Dentro de la carpeta de la práctica que quieras ejecutar:

```bash
az login
terraform init
terraform plan -out plan.tfplan
terraform apply plan.tfplan
# al terminar, para no generar costos:
terraform destroy
```

La suscripción se pasa por la variable `subscription_id` (marcada como `sensitive`); no hay credenciales en el repositorio. Define tus valores en un `terraform.tfvars` propio o por variables de entorno `TF_VAR_*`.

> Nota: estos laboratorios crean recursos reales en Azure que **pueden generar costos**. Ejecuta `terraform destroy` al terminar cada práctica.

## Tecnologías

Terraform · Azure Resource Manager (azurerm) · Azure CLI

---

Prácticas de Luis Enrique González Ramírez — [github.com/KikeGonRam](https://github.com/KikeGonRam)
