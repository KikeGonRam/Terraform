# Terraform · Laboratorios IDGS-103

**Infraestructura como código con Terraform sobre Microsoft Azure** (materia IDGS-103, Universidad Tecnológica del Valle de Toluca). Va de los primeros recursos a un despliegue completo con red, base de datos, almacenamiento y cómputo.

[![Seguridad](https://github.com/KikeGonRam/Terraform/actions/workflows/security.yml/badge.svg)](https://github.com/KikeGonRam/Terraform/actions/workflows/security.yml)
![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A51.13-7B42BC?logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-azurerm%205.0-0078D4?logo=microsoftazure&logoColor=white)

[Seguridad](SECURITY.md)

## Contenido

| Carpeta | Qué despliega | Tecnología |
| --- | --- | --- |
| `Practica1/Laboratorio1` | Resource group y red virtual | azurerm |
| `Practica1/Laboratorio2` | Resource group y VNet con variables y `locals` | azurerm |
| `Practica1/Laboratorio3` | App Service (Linux), Log Analytics y Application Insights | azurerm |
| `practica3/` | Proyecto integrador: VNet, NSG, PostgreSQL, Blob, VM, Bastion y App Service | azurerm |

La práctica 3 incluye su propia documentación: **[practica3/README.md](practica3/README.md)** y **[practica3/VALIDACION.md](practica3/VALIDACION.md)**.

## Requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.13
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) con sesión iniciada (`az login`)
- Una suscripción de Azure propia

## Uso

Dentro de la carpeta de la práctica:

```bash
az login
terraform init
terraform plan -out plan.tfplan
terraform apply plan.tfplan
terraform destroy          # al terminar, para no generar costos
```

La suscripción se pasa por la variable `subscription_id` (marcada como `sensitive`); no
hay credenciales en el repositorio. Define tus valores en un `terraform.tfvars` propio o
por variables `TF_VAR_*`.

> Estos laboratorios crean recursos reales en Azure que **pueden generar costos**.
> Ejecuta `terraform destroy` al terminar cada práctica.

## Seguridad

El análisis estático (Semgrep con reglas de Terraform) y el escaneo de secretos
(Gitleaks) corren en cada *push* y PR (ver [workflow](.github/workflows/security.yml)).
El estado de Terraform (`*.tfstate`) y los datos de sesión no se versionan. Reporta
vulnerabilidades según [SECURITY.md](SECURITY.md).

## Tecnologías

Terraform · Azure Resource Manager (azurerm) · Azure CLI

---

Prácticas de Luis Enrique González Ramírez — [github.com/KikeGonRam](https://github.com/KikeGonRam)
