# Integración WordPress ↔ n8n — Tienwi

## Patrón 1: Webhook desde WordPress hacia n8n

Cuando ocurre un evento en WordPress y necesitas disparar un flujo en n8n:

```php
// En functions.php del tema hijo o en plugin personalizado

add_action( 'woocommerce_order_status_changed', 'tienwi_notificar_n8n_orden', 10, 4 );

function tienwi_notificar_n8n_orden( $order_id, $old_status, $new_status, $order ) {
    $webhook_url = 'https://TU-N8N.com/webhook/woo-order-status';

    $payload = array(
        'order_id'   => $order_id,
        'old_status' => $old_status,
        'new_status' => $new_status,
        'total'      => $order->get_total(),
        'email'      => $order->get_billing_email(),
        'cliente'    => $order->get_billing_first_name() . ' ' . $order->get_billing_last_name(),
    );

    wp_remote_post( $webhook_url, array(
        'headers'     => array( 'Content-Type' => 'application/json' ),
        'body'        => wp_json_encode( $payload ),
        'timeout'     => 15,
        'blocking'    => false, // no esperar respuesta para no ralentizar WP
    ));
}
```

---

## Patrón 2: Endpoint REST personalizado para n8n

Cuando n8n necesita consultar o enviar datos a WordPress:

```php
add_action( 'rest_api_init', 'tienwi_registrar_endpoints' );

function tienwi_registrar_endpoints() {
    // Endpoint para recibir datos desde n8n
    register_rest_route( 'tienwi/v1', '/sync-producto', array(
        'methods'             => 'POST',
        'callback'            => 'tienwi_sync_producto',
        'permission_callback' => 'tienwi_verificar_api_key',
    ));

    // Endpoint para que n8n consulte datos
    register_rest_route( 'tienwi/v1', '/pedidos-pendientes', array(
        'methods'             => 'GET',
        'callback'            => 'tienwi_obtener_pedidos',
        'permission_callback' => 'tienwi_verificar_api_key',
    ));
}

// Autenticación por API Key (más simple que OAuth para n8n)
function tienwi_verificar_api_key( $request ) {
    $api_key = $request->get_header( 'X-Tienwi-Key' );
    return $api_key === get_option( 'tienwi_api_key' );
}

function tienwi_sync_producto( $request ) {
    $datos = $request->get_json_params();

    // Validar datos mínimos
    if ( empty( $datos['sku'] ) ) {
        return new WP_Error( 'datos_invalidos', 'SKU requerido', array( 'status' => 400 ) );
    }

    // Buscar producto por SKU
    $product_id = wc_get_product_id_by_sku( $datos['sku'] );

    if ( ! $product_id ) {
        return new WP_Error( 'no_encontrado', 'Producto no existe', array( 'status' => 404 ) );
    }

    $producto = wc_get_product( $product_id );
    $producto->set_stock_quantity( absint( $datos['stock'] ) );
    $producto->save();

    return rest_ensure_response( array(
        'success'    => true,
        'product_id' => $product_id,
        'stock'      => $datos['stock'],
    ));
}
```

**URL del endpoint**: `https://TU-SITIO.com/wp-json/tienwi/v1/sync-producto`

**Header en n8n**:
```
X-Tienwi-Key: TU_API_KEY_SECRETA
Content-Type: application/json
```

---

## Patrón 3: Configurar en n8n

En el nodo **HTTP Request** de n8n:
- Method: `POST`
- URL: `https://TU-SITIO.com/wp-json/tienwi/v1/sync-producto`
- Headers: `X-Tienwi-Key` = tu clave
- Body: JSON con los datos

---

## Hooks de WooCommerce más usados con n8n

```php
// Nuevo pedido creado
add_action( 'woocommerce_new_order', 'callback', 10, 2 );

// Pedido completado
add_action( 'woocommerce_order_status_completed', 'callback', 10, 1 );

// Nuevo cliente registrado
add_action( 'woocommerce_created_customer', 'callback', 10, 3 );

// Producto actualizado
add_action( 'woocommerce_update_product', 'callback', 10, 2 );

// Formulario de contacto enviado (Contact Form 7)
add_action( 'wpcf7_mail_sent', 'callback', 10, 1 );
```
