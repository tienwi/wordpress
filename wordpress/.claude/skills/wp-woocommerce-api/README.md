# wp-woocommerce-api

Skill con conocimiento completo de la WordPress REST API y la WooCommerce REST API para proyectos Tienwi.

---

## Purpose

Guía al agente en autenticación, consulta y modificación de recursos vía API: posts, páginas, usuarios, productos, pedidos, clientes, cupones, webhooks y creación de endpoints personalizados.

## Activates On

- wordpress rest api
- woocommerce rest api
- wp-json
- wc/v3
- consumer key
- consumer secret
- application password
- jwt wordpress
- endpoint personalizado
- register_rest_route
- WP_REST_Request
- WP_REST_Response
- WP_Error rest
- productos woocommerce api
- pedidos api
- clientes api woocommerce
- cupones api
- variaciones producto api
- webhook woocommerce
- n8n woocommerce
- sincronizar woocommerce
- stock api
- batch products
- orders api
- customers api
- paginación rest api

## Coverage

### WordPress REST API
1. **Autenticación** — Application Passwords, JWT
2. **Posts** — CRUD completo con meta fields
3. **Páginas** — gestión vía API
4. **Medios** — subida de imágenes
5. **Usuarios** — crear, editar, eliminar
6. **Taxonomías** — categorías y etiquetas
7. **Meta fields** — registro con `show_in_rest` y uso en requests
8. **Endpoints personalizados** — `register_rest_route`, validación, permisos, errores

### WooCommerce REST API (wc/v3)
9. **Autenticación** — Consumer Key/Secret
10. **Productos** — simples, variables, variaciones, batch updates
11. **Pedidos** — crear, actualizar estado, notas, filtros por estado
12. **Clientes** — crear, buscar, historial de pedidos
13. **Cupones** — crear, configurar descuentos y restricciones
14. **Categorías** — gestión con imágenes y jerarquía
15. **Reportes** — ventas, top sellers, totales
16. **Webhooks** — crear y verificar firma HMAC-SHA256

### Integración
17. **n8n ↔ WooCommerce** — configuración HTTP Request, patrones de workflow
18. **Verificación de webhooks** — validar firma en n8n con nodo Code
19. **Paginación y filtros** — `per_page`, `page`, headers `X-WP-Total`
20. **Errores comunes** — tabla de diagnóstico y soluciones
