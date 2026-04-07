# Decisiones Técnicas — Tienwi Agency

Actualizado: 2026-04-06

---

## Arquitectura y estándares

- **Tema hijo siempre:** Nunca editar el tema padre directamente
- **Prefijo de código:** `tienwi_` para funciones, clases, opciones y tablas custom
- **PHP mínimo:** 7.4+ compatible
- **Scripts/estilos:** Siempre con `wp_enqueue_scripts()`, nunca hardcodeado
- **Queries BD:** Siempre con `$wpdb->prepare()`
- **Sanitización:** Obligatoria en todos los inputs del usuario

## Integraciones

- **Automatización:** n8n como plataforma principal de automatización
- **Webhooks:** WooCommerce → n8n para eventos de pedidos y productos
- **Autenticación API:** Application Passwords para n8n ↔ WordPress

## Hosting

- **Plataforma:** cPanel (servidores compartidos y VPS)
- **BD:** MySQL/MariaDB

## Gestión de proyectos

- **Tareas:** ClickUp
- **Versiones:** Git + GitHub (organización: tienwi)

---

> Registrar aquí decisiones técnicas importantes que afecten a todos los proyectos.
