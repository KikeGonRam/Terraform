# Política de seguridad

Revisión: 21 de noviembre de 2026.

## Alcance

Las correcciones se preparan mediante *pull request* contra `main`. Al reportar, indica
el commit (SHA), *tag* o versión afectada y el entorno donde observaste el problema.
Que exista una versión anterior no implica que siga desplegada ni que esté libre de
fallos. Este proyecto no ofrece un plazo de respuesta (SLA) ni recompensas.

## Reportar en privado

Usa **[Report a vulnerability](https://github.com/KikeGonRam/Terraform/security/advisories/new)**;
el reporte privado está habilitado en este repositorio.

Incluye:

- Componente y commit o versión afectada.
- Comportamiento observado, impacto y alcance estimado.
- Pasos mínimos para reproducir en un entorno aislado, con datos ficticios.
- Evidencia depurada y, si la tienes, una propuesta de mitigación.

No publiques secretos, cookies, cabeceras `Authorization`, URLs firmadas, datos
personales ni *dumps* en *issues*, PR, *logs* o capturas. Los fallos funcionales sin
información sensible pueden ir a
[Issues](https://github.com/KikeGonRam/Terraform/issues).

## Si se expone una credencial

Comunica en privado la ubicación y el tipo de credencial, **sin reproducir el valor**.
Eliminar un archivo o un commit actual no borra su contenido del historial de Git:
la credencial debe **revocarse o rotarse**, no solo quitarse del repositorio.

## Controles

Las alertas de Dependabot, el escaneo de secretos y el análisis estático de CI son
controles complementarios. Un resultado verde no certifica ausencia de
vulnerabilidades. Los secretos se administran **fuera del repositorio** (variables de
entorno o *secrets* del gestor de despliegue), nunca versionados.
