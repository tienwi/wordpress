# wp-plugin-development

Skill para desarrollar plugins WordPress personalizados siguiendo los estándares de Tienwi Agency.

---

## Purpose

Guía al agente en la creación, estructura y buenas prácticas de plugins WordPress: desde el header hasta AJAX seguro, CPTs, shortcodes y páginas de administración.

## Activates On

- crear plugin
- desarrollar plugin
- plugin wordpress
- custom post type
- cpt registro
- shortcode
- hook wordpress
- filter wordpress
- wp_enqueue
- enqueue scripts
- admin page
- settings api
- ajax wordpress
- wp_ajax
- activación plugin
- desactivación plugin
- dbDelta
- register_post_type
- wp_localize_script
- sanitize_text_field
- $wpdb->prepare
- nonce wordpress

## Coverage

1. **Estructura de archivos** — carpetas y nombres recomendados para plugins Tienwi
2. **Header del plugin** — metadatos obligatorios y constantes
3. **Patrón singleton** — clase principal segura
4. **Custom Post Types** — registro con soporte REST y Gutenberg
5. **Shortcodes** — atributos, sanitización, output buffering
6. **Seguridad** — sanitización, nonces, `$wpdb->prepare()`
7. **Hooks de ciclo de vida** — activación, desactivación, tablas custom
8. **Admin UI** — menús, Settings API, páginas de opciones
9. **AJAX** — handlers seguros con nonce y `wp_send_json_*`
10. **Checklist de entrega** — revisión antes de poner en producción
