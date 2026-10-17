# Validación local de practica3

Fecha: 16 de octubre de 2026.

- Terraform 1.16.2 y AzureRM 5.0.0 instalado con firma de HashiCorp.
- terraform init -backend=false -input=false: correcto.
- terraform fmt -check: correcto.
- terraform validate: Success! The configuration is valid.
- terraform plan: 50 recursos por crear, 0 por modificar y 0 por destruir.
- Sesión Azure for Students consultada para generar el plan.
- Plan guardado en .local/practica3.tfplan; log local en .local/plan.txt.
- No se ejecutó terraform apply. No se creó infraestructura de esta práctica.
- Disponibilidad regional, cuota, coste y restricciones de Azure todavía deben verificarse en el despliegue.
- Las conexiones SQL/Blob, roles internos PostgreSQL y código de aplicación requieren comprobación después del aprovisionamiento.

## Ejecución posterior del alumno

Las 20 capturas de terminal del 16 de octubre de 2026 entre 18:01:28 y 18:03:21 documentan init y validate correctos, plan de 50 creaciones y un intento de apply. El grupo rg-utvt-tf4-dev-001 se creó; varios recursos fueron rechazados con HTTP 403 RequestDisallowedByAzure por restricción de regiones. El despliegue quedó incompleto. El estado local revisado registra el grupo de recursos y la consulta de configuración del cliente. Esta ejecución posterior sustituye el estado previo de no aplicación indicado arriba.

Reporte: Reporte_Terraform4_Practica3.docx, 23 páginas, 20 capturas y diagrama de referencia. No se ejecutó otro apply ni se cambió región durante la preparación del reporte.

