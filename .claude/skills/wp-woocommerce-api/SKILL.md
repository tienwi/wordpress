---
name: wp-woocommerce-api
description: Conocimiento completo de la WordPress REST API y la WooCommerce REST API para Tienwi. Úsalo cuando necesites consultar o modificar posts, páginas, productos, pedidos, clientes, cupones, categorías, usuarios, o cuando debas crear endpoints personalizados, autenticar requests, o conectar n8n con WordPress/WooCommerce vía API.
---

# WordPress REST API + WooCommerce REST API

Guía de referencia completa para consumir y extender las APIs de WordPress y WooCommerce en proyectos Tienwi.

---

## WordPress REST API

### Base URL

```
https://tudominio.com/wp-json/wp/v2/
```

### Autenticación

#### Application Passwords (recomendado para n8n)
1. En WordPress: Usuario → Editar → Application Passwords → Agregar nueva
2. Usar en cada request como Basic Auth:
```
Authorization: Basic base64(usuario:app_password)
```

#### JWT (plugin JWT Authentication for WP REST API)
```
POST /wp-json/jwt-auth/v1/token
Body: { "username": "...", "password": "..." }
→ Devuelve: { "token": "eyJ..." }

Luego: Authorization: Bearer eyJ...
```

---

### Endpoints WordPress más usados

#### Posts

```http
# Listar posts publicados
GET /wp-json/wp/v2/posts?status=publish&per_page=10&page=1

# Buscar posts
GET /wp-json/wp/v2/posts?search=texto&per_page=5

# Obtener un post por ID
GET /wp-json/wp/v2/posts/123

# Crear post
POST /wp-json/wp/v2/posts
Content-Type: application/json
{
  "title": "Mi Post",
  "content": "Contenido del post",
  "status": "publish",
  "categories": [5, 8],
  "tags": [12],
  "meta": {
    "mi_campo_custom": "valor"
  }
}

# Actualizar post
POST /wp-json/wp/v2/posts/123
{ "title": "Título actualizado", "status": "draft" }

# Eliminar post (mover a papelera)
DELETE /wp-json/wp/v2/posts/123

# Eliminar permanentemente
DELETE /wp-json/wp/v2/posts/123?force=true
```

#### Páginas

```http
GET  /wp-json/wp/v2/pages
GET  /wp-json/wp/v2/pages/123
POST /wp-json/wp/v2/pages       # Crear
POST /wp-json/wp/v2/pages/123   # Actualizar
```

#### Medios (Media)

```http
# Subir imagen
POST /wp-json/wp/v2/media
Content-Type: image/jpeg
Content-Disposition: attachment; filename="foto.jpg"
[binary data]

# Listar medios
GET /wp-json/wp/v2/media?media_type=image&per_page=20
```

#### Usuarios

```http
GET  /wp-json/wp/v2/users          # Lista (requiere auth)
GET  /wp-json/wp/v2/users/me       # Usuario actual
GET  /wp-json/wp/v2/users/5        # Por ID
POST /wp-json/wp/v2/users          # Crear usuario
POST /wp-json/wp/v2/users/5        # Actualizar
DELETE /wp-json/wp/v2/users/5?reassign=1  # Eliminar (reasignar contenido al ID 1)
```

#### Taxonomías (categorías y etiquetas)

```http
GET  /wp-json/wp/v2/categories
GET  /wp-json/wp/v2/categories?parent=0    # Solo categorías raíz
POST /wp-json/wp/v2/categories
{ "name": "Nueva Categoría", "slug": "nueva-categoria", "parent": 0 }

GET  /wp-json/wp/v2/tags
POST /wp-json/wp/v2/tags
{ "name": "Nueva Etiqueta" }
```

---

### Campos personalizados (meta) en REST API

Para exponer meta fields en la API, registrarlos correctamente:

```php
// En functions.php o plugin
register_post_meta( 'post', 'mi_campo', array(
    'show_in_rest' => true,
    'single'       => true,
    'type'         => 'string',
    'auth_callback' => function() {
        return current_user_can( 'edit_posts' );
    },
) );
```

Luego en el request:
```json
{ "meta": { "mi_campo": "valor" } }
```

---

### Crear endpoint REST personalizado

```php
add_action( 'rest_api_init', function() {
    register_rest_route( 'tienwi/v1', '/datos', array(
        'methods'             => WP_REST_Server::READABLE, // GET
        'callback'            => 'tienwi_get_datos',
        'permission_callback' => 'tienwi_check_api_key',
        'args'                => array(
            'limite' => array(
                'required'          => false,
                'default'           => 10,
                'sanitize_callback' => 'absint',
                'validate_callback' => function( $val ) {
                    return $val > 0 && $val <= 100;
                },
            ),
        ),
    ) );

    register_rest_route( 'tienwi/v1', '/datos', array(
        'methods'             => WP_REST_Server::CREATABLE, // POST
        'callback'            => 'tienwi_post_datos',
        'permission_callback' => 'tienwi_check_api_key',
    ) );
} );

function tienwi_check_api_key( WP_REST_Request $request ) {
    $api_key = $request->get_header( 'X-Tienwi-Key' );
    return $api_key === get_option( 'tienwi_api_key' );
}

function tienwi_get_datos( WP_REST_Request $request ) {
    $limite = $request->get_param( 'limite' );
    // ... lógica ...
    return new WP_REST_Response( array( 'datos' => $resultado ), 200 );
}

function tienwi_post_datos( WP_REST_Request $request ) {
    $body = $request->get_json_params();
    $nombre = sanitize_text_field( $body['nombre'] ?? '' );

    if ( empty( $nombre ) ) {
        return new WP_Error( 'campo_requerido', 'El nombre es requerido', array( 'status' => 400 ) );
    }

    // ... guardar datos ...
    return new WP_REST_Response( array( 'mensaje' => 'Guardado', 'id' => $nuevo_id ), 201 );
}
```

**URL del endpoint:** `https://tudominio.com/wp-json/tienwi/v1/datos`

---

## WooCommerce REST API

### Base URL

```
https://tudominio.com/wp-json/wc/v3/
```

### Autenticación WooCommerce

Usar Consumer Key + Consumer Secret (generados en WooCommerce → Ajustes → Avanzado → REST API):

```
# HTTPS: parámetros en query string o Basic Auth
GET /wp-json/wc/v3/products?consumer_key=ck_xxx&consumer_secret=cs_xxx

# O como Basic Auth:
Authorization: Basic base64(ck_xxx:cs_xxx)
```

---

### Productos

```http
# Listar productos
GET /wp-json/wc/v3/products?per_page=20&page=1&status=publish

# Filtros útiles
GET /wp-json/wc/v3/products?category=15&stock_status=instock&orderby=price&order=asc

# Producto por ID
GET /wp-json/wc/v3/products/456

# Crear producto simple
POST /wp-json/wc/v3/products
{
  "name": "Camisa Azul",
  "type": "simple",
  "regular_price": "45000",
  "sale_price": "38000",
  "description": "Descripción larga...",
  "short_description": "Descripción corta",
  "categories": [{"id": 15}],
  "images": [{"src": "https://...jpg"}],
  "manage_stock": true,
  "stock_quantity": 100,
  "sku": "CAM-AZUL-001",
  "weight": "0.3",
  "dimensions": {"length": "30", "width": "20", "height": "2"}
}

# Crear producto variable
POST /wp-json/wc/v3/products
{
  "name": "Camisa",
  "type": "variable",
  "attributes": [{
    "name": "Talla",
    "position": 0,
    "visible": true,
    "variation": true,
    "options": ["S", "M", "L", "XL"]
  }]
}

# Actualizar precio y stock
POST /wp-json/wc/v3/products/456
{
  "regular_price": "50000",
  "stock_quantity": 80
}

# Eliminar producto
DELETE /wp-json/wc/v3/products/456?force=true
```

#### Variaciones de producto

```http
# Listar variaciones
GET /wp-json/wc/v3/products/456/variations

# Crear variación
POST /wp-json/wc/v3/products/456/variations
{
  "regular_price": "45000",
  "attributes": [{"name": "Talla", "option": "M"}],
  "manage_stock": true,
  "stock_quantity": 30,
  "sku": "CAM-AZUL-M"
}

# Actualizar variación
POST /wp-json/wc/v3/products/456/variations/789
{ "stock_quantity": 15 }
```

#### Actualización masiva de productos

```http
POST /wp-json/wc/v3/products/batch
{
  "create": [{ "name": "Nuevo producto", "regular_price": "20000" }],
  "update": [{ "id": 456, "regular_price": "55000" }],
  "delete": [789]
}
```

---

### Pedidos (Orders)

```http
# Listar pedidos
GET /wp-json/wc/v3/orders?status=processing&per_page=20

# Estados disponibles: pending, processing, on-hold, completed, cancelled, refunded, failed

# Pedido por ID
GET /wp-json/wc/v3/orders/101

# Crear pedido
POST /wp-json/wc/v3/orders
{
  "payment_method": "bacs",
  "payment_method_title": "Transferencia Bancaria",
  "set_paid": false,
  "billing": {
    "first_name": "Juan",
    "last_name": "García",
    "email": "juan@email.com",
    "phone": "3001234567",
    "address_1": "Calle 100 # 15-30",
    "city": "Bogotá",
    "country": "CO"
  },
  "shipping": {
    "first_name": "Juan",
    "last_name": "García",
    "address_1": "Calle 100 # 15-30",
    "city": "Bogotá",
    "country": "CO"
  },
  "line_items": [
    { "product_id": 456, "quantity": 2 },
    { "product_id": 789, "variation_id": 101, "quantity": 1 }
  ],
  "shipping_lines": [
    { "method_id": "flat_rate", "method_title": "Envío estándar", "total": "8000" }
  ]
}

# Actualizar estado del pedido
POST /wp-json/wc/v3/orders/101
{ "status": "completed" }

# Agregar nota al pedido
POST /wp-json/wc/v3/orders/101/notes
{
  "note": "Guía de envío: TCC123456",
  "customer_note": false
}
```

---

### Clientes (Customers)

```http
# Listar clientes
GET /wp-json/wc/v3/customers?per_page=20&role=customer

# Buscar por email
GET /wp-json/wc/v3/customers?email=juan@email.com

# Cliente por ID
GET /wp-json/wc/v3/customers/55

# Crear cliente
POST /wp-json/wc/v3/customers
{
  "email": "nuevo@email.com",
  "first_name": "Ana",
  "last_name": "López",
  "username": "ana.lopez",
  "password": "Password123!",
  "billing": { "phone": "3009876543" }
}

# Historial de pedidos de un cliente
GET /wp-json/wc/v3/orders?customer=55
```

---

### Cupones (Coupons)

```http
# Listar cupones
GET /wp-json/wc/v3/coupons

# Crear cupón
POST /wp-json/wc/v3/coupons
{
  "code": "DESCUENTO20",
  "discount_type": "percent",       # percent | fixed_cart | fixed_product
  "amount": "20",
  "individual_use": true,
  "usage_limit": 100,
  "usage_limit_per_user": 1,
  "date_expires": "2026-12-31T23:59:59",
  "minimum_amount": "50000",
  "product_ids": [],               # vacío = aplica a todo
  "excluded_product_ids": []
}

# Actualizar cupón
POST /wp-json/wc/v3/coupons/33
{ "usage_limit": 200 }
```

---

### Categorías de productos

```http
# Listar categorías
GET /wp-json/wc/v3/products/categories?per_page=100&hide_empty=false

# Crear categoría
POST /wp-json/wc/v3/products/categories
{
  "name": "Ropa Deportiva",
  "slug": "ropa-deportiva",
  "parent": 0,
  "description": "Toda la línea deportiva",
  "image": { "src": "https://...jpg" }
}
```

---

### Reportes

```http
# Ventas totales
GET /wp-json/wc/v3/reports/sales?date_min=2026-01-01&date_max=2026-03-31

# Productos más vendidos
GET /wp-json/wc/v3/reports/top_sellers?period=month

# Totales de la tienda
GET /wp-json/wc/v3/reports/totals
```

---

### Webhooks de WooCommerce

```http
# Crear webhook (WC notifica a n8n cuando ocurre un evento)
POST /wp-json/wc/v3/webhooks
{
  "name": "Pedido creado → n8n",
  "topic": "order.created",
  "delivery_url": "https://n8n.tienwi.com/webhook/wc-pedido",
  "secret": "mi_secreto_seguro",
  "status": "active"
}

# Topics disponibles:
# order.created | order.updated | order.deleted | order.restored
# product.created | product.updated | product.deleted
# customer.created | customer.updated | customer.deleted
# coupon.created | coupon.updated | coupon.deleted
```

---

## Integración n8n ↔ WordPress/WooCommerce

### Configuración en n8n (nodo HTTP Request)

```
URL: https://tudominio.com/wp-json/wc/v3/orders
Method: GET
Authentication: Basic Auth
  Username: ck_xxxxxxxxxxxxx
  Password: cs_xxxxxxxxxxxxx
```

### Patrón típico: Sincronizar pedido nuevo con CRM

```
[WC Webhook] → [n8n Webhook node]
    → [IF pedido.status == "processing"]
    → [HTTP Request: GET /customers/{id}]
    → [HTTP Request: POST CRM /contactos]
    → [HTTP Request: POST /orders/{id}/notes con ID del CRM]
```

### Autenticación de webhooks WC entrantes en n8n

WooCommerce envía el header `X-WC-Webhook-Signature` con HMAC-SHA256 del body usando el secret. Verificar en n8n con nodo Code:

```javascript
const crypto = require('crypto');
const secret = 'mi_secreto_seguro';
const body = $input.first().json.body; // raw body como string
const signature = $input.first().headers['x-wc-webhook-signature'];

const esperado = crypto
  .createHmac('sha256', secret)
  .update(body)
  .digest('base64');

if (signature !== esperado) {
  throw new Error('Firma inválida - webhook rechazado');
}

return $input.all();
```

---

## Errores comunes y soluciones

| Error | Causa | Solución |
|-------|-------|----------|
| `rest_no_route` | Endpoint no existe o plugin desactivado | Verificar URL y que WooCommerce esté activo |
| `woocommerce_rest_cannot_view` | Sin permisos | Usar credenciales con permisos Read/Write |
| `rest_forbidden` | Authentication fallida | Verificar consumer key/secret o application password |
| `rest_invalid_param` | Parámetro inválido | Revisar tipos de datos (string vs número) |
| `401 Unauthorized` | Problema con SSL o auth | Asegurar HTTPS activo, revisar credenciales |
| Stock no actualiza | Cache de WooCommerce | Vaciar caché después de actualizar stock |

---

## Parámetros de paginación y filtrado

```http
# Paginación estándar (ambas APIs)
?per_page=20&page=2

# Respuesta incluye headers:
# X-WP-Total: 245        (total de items)
# X-WP-TotalPages: 13    (total de páginas)

# Ordenamiento
?orderby=date&order=desc    # date, id, title, slug, price (WC)

# Fechas (formato ISO 8601)
?after=2026-01-01T00:00:00&before=2026-03-31T23:59:59

# Búsqueda
?search=camisa
```
