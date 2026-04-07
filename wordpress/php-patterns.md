# Patrones PHP recomendados — WordPress Tienwi

## Estructura base de un plugin

```php
<?php
/**
 * Plugin Name: Tienwi Custom Plugin
 * Description: Plugin personalizado para cliente X
 * Version: 1.0.0
 * Author: Tienwi Agency
 */

// Seguridad: evitar acceso directo
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

// Constantes del plugin
define( 'TIENWI_PLUGIN_VERSION', '1.0.0' );
define( 'TIENWI_PLUGIN_PATH', plugin_dir_path( __FILE__ ) );
define( 'TIENWI_PLUGIN_URL', plugin_dir_url( __FILE__ ) );

// Inicializar el plugin
add_action( 'plugins_loaded', 'tienwi_init' );

function tienwi_init() {
    // Lógica principal aquí
}
```

---

## Hooks — Actions y Filters

```php
// ACTION: ejecutar código en un punto específico
add_action( 'wp_footer', 'tienwi_footer_scripts' );
function tienwi_footer_scripts() {
    echo '<script>console.log("Tienwi");</script>';
}

// FILTER: modificar un valor antes de usarlo
add_filter( 'the_title', 'tienwi_modify_title', 10, 2 );
function tienwi_modify_title( $title, $post_id ) {
    if ( get_post_type( $post_id ) === 'product' ) {
        return $title . ' — Tienwi';
    }
    return $title;
}

// Remover hook de un plugin de tercero
remove_action( 'wp_head', array( PluginClass::get_instance(), 'method_name' ), 10 );
```

---

## Enqueue correcto de scripts y estilos

```php
add_action( 'wp_enqueue_scripts', 'tienwi_enqueue_assets' );
function tienwi_enqueue_assets() {
    // Estilo
    wp_enqueue_style(
        'tienwi-style',
        TIENWI_PLUGIN_URL . 'assets/css/main.css',
        array(), // dependencias
        TIENWI_PLUGIN_VERSION
    );

    // Script con dependencia en jQuery
    wp_enqueue_script(
        'tienwi-script',
        TIENWI_PLUGIN_URL . 'assets/js/main.js',
        array( 'jquery' ),
        TIENWI_PLUGIN_VERSION,
        true // cargar en footer
    );

    // Pasar variables PHP a JS
    wp_localize_script( 'tienwi-script', 'tienwiVars', array(
        'ajaxUrl' => admin_url( 'admin-ajax.php' ),
        'nonce'   => wp_create_nonce( 'tienwi_nonce' ),
    ));
}
```

---

## Sanitización y validación (CRÍTICO)

```php
// INPUTS — siempre sanitizar al recibir
$nombre     = sanitize_text_field( $_POST['nombre'] ?? '' );
$email      = sanitize_email( $_POST['email'] ?? '' );
$numero     = absint( $_POST['cantidad'] ?? 0 );
$html       = wp_kses_post( $_POST['descripcion'] ?? '' ); // permite HTML seguro
$url        = esc_url_raw( $_POST['url'] ?? '' );

// OUTPUTS — siempre escapar al mostrar
echo esc_html( $nombre );
echo esc_attr( $atributo );    // dentro de atributos HTML
echo esc_url( $url );          // en href/src
echo wp_kses_post( $contenido ); // HTML controlado
```

---

## Queries a base de datos

```php
global $wpdb;

// CORRECTO — usar prepare() siempre con variables
$resultado = $wpdb->get_results(
    $wpdb->prepare(
        "SELECT * FROM {$wpdb->prefix}posts WHERE post_author = %d AND post_status = %s",
        $user_id,
        'publish'
    )
);

// Insertar
$wpdb->insert(
    $wpdb->prefix . 'tienwi_logs',
    array(
        'usuario' => $user_id,
        'accion'  => $accion,
        'fecha'   => current_time( 'mysql' ),
    ),
    array( '%d', '%s', '%s' )
);

// NUNCA hacer esto:
// $wpdb->query( "SELECT * FROM wp_posts WHERE ID = " . $_GET['id'] ); // SQL injection!
```

---

## Opciones y transients

```php
// Guardar opción persistente
update_option( 'tienwi_config', array( 'key' => 'value' ) );
$config = get_option( 'tienwi_config', array() ); // segundo param = default

// Transient (cache temporal)
$data = get_transient( 'tienwi_productos_cache' );
if ( false === $data ) {
    $data = tienwi_obtener_productos_api(); // llamada costosa
    set_transient( 'tienwi_productos_cache', $data, HOUR_IN_SECONDS );
}

// Eliminar transient (al guardar cambios)
delete_transient( 'tienwi_productos_cache' );
```

---

## AJAX en WordPress

```php
// Registrar el handler
add_action( 'wp_ajax_tienwi_accion', 'tienwi_ajax_handler' );        // usuarios logueados
add_action( 'wp_ajax_nopriv_tienwi_accion', 'tienwi_ajax_handler' ); // todos

function tienwi_ajax_handler() {
    // Verificar nonce
    check_ajax_referer( 'tienwi_nonce', 'nonce' );

    // Verificar permisos si es necesario
    if ( ! current_user_can( 'edit_posts' ) ) {
        wp_send_json_error( 'Sin permisos', 403 );
    }

    $dato = sanitize_text_field( $_POST['dato'] ?? '' );

    // Procesar...

    wp_send_json_success( array( 'resultado' => $dato ) );
}
```
