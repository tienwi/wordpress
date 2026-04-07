---
name: wp-plugin-development
description: Desarrollo de plugins WordPress personalizados para Tienwi. Úsalo cuando necesites crear un plugin desde cero, agregar shortcodes, registrar CPTs, crear endpoints REST, usar hooks/filters, encolar scripts/estilos, o seguir los estándares de WordPress Coding Standards en código PHP.
---

# WordPress Plugin Development

Guía para desarrollar plugins WordPress siguiendo los estándares de Tienwi Agency.

---

## Estructura mínima de un plugin

```
wp-content/plugins/tienwi-mi-plugin/
├── tienwi-mi-plugin.php        ← Archivo principal (header + bootstrap)
├── includes/
│   ├── class-mi-feature.php    ← Lógica principal en clases
│   └── helpers.php             ← Funciones reutilizables
├── admin/
│   ├── class-admin.php         ← Páginas de administración
│   └── views/                  ← Plantillas HTML del admin
├── assets/
│   ├── css/
│   └── js/
└── languages/                  ← Archivos .pot para i18n
```

---

## Header obligatorio del plugin

```php
<?php
/**
 * Plugin Name:       Tienwi Mi Plugin
 * Plugin URI:        https://tienwi.com
 * Description:       Descripción breve del plugin.
 * Version:           1.0.0
 * Requires at least: 6.0
 * Requires PHP:      7.4
 * Author:            Tienwi Agency
 * Author URI:        https://tienwi.com
 * License:           GPL v2 or later
 * Text Domain:       tienwi-mi-plugin
 * Domain Path:       /languages
 */

// Seguridad: impedir acceso directo
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

// Constantes del plugin
define( 'TIENWI_PLUGIN_VERSION', '1.0.0' );
define( 'TIENWI_PLUGIN_DIR', plugin_dir_path( __FILE__ ) );
define( 'TIENWI_PLUGIN_URL', plugin_dir_url( __FILE__ ) );
```

---

## Patrones PHP esenciales

### Clase principal con singleton

```php
class Tienwi_Mi_Plugin {

    private static $instance = null;

    public static function get_instance() {
        if ( null === self::$instance ) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct() {
        $this->hooks();
    }

    private function hooks() {
        add_action( 'init', array( $this, 'init' ) );
        add_action( 'wp_enqueue_scripts', array( $this, 'enqueue_scripts' ) );
    }

    public function init() {
        // Lógica de inicialización
    }

    public function enqueue_scripts() {
        wp_enqueue_style(
            'tienwi-plugin-style',
            TIENWI_PLUGIN_URL . 'assets/css/main.css',
            array(),
            TIENWI_PLUGIN_VERSION
        );
        wp_enqueue_script(
            'tienwi-plugin-script',
            TIENWI_PLUGIN_URL . 'assets/js/main.js',
            array( 'jquery' ),
            TIENWI_PLUGIN_VERSION,
            true // En el footer
        );
    }
}

// Iniciar el plugin
add_action( 'plugins_loaded', array( Tienwi_Mi_Plugin::class, 'get_instance' ) );
```

---

## Custom Post Types (CPT)

```php
public function register_cpt() {
    $labels = array(
        'name'               => __( 'Proyectos', 'tienwi-plugin' ),
        'singular_name'      => __( 'Proyecto', 'tienwi-plugin' ),
        'add_new'            => __( 'Añadir nuevo', 'tienwi-plugin' ),
        'add_new_item'       => __( 'Añadir nuevo proyecto', 'tienwi-plugin' ),
        'edit_item'          => __( 'Editar proyecto', 'tienwi-plugin' ),
        'search_items'       => __( 'Buscar proyectos', 'tienwi-plugin' ),
        'not_found'          => __( 'No se encontraron proyectos', 'tienwi-plugin' ),
    );

    $args = array(
        'labels'             => $labels,
        'public'             => true,
        'has_archive'        => true,
        'rewrite'            => array( 'slug' => 'proyectos' ),
        'supports'           => array( 'title', 'editor', 'thumbnail', 'custom-fields' ),
        'show_in_rest'       => true, // Habilitar Gutenberg y REST API
        'menu_icon'          => 'dashicons-portfolio',
    );

    register_post_type( 'tienwi_proyecto', $args );
}
add_action( 'init', 'register_cpt' );
```

---

## Shortcodes

```php
public function register_shortcodes() {
    add_shortcode( 'tienwi_lista', array( $this, 'shortcode_lista' ) );
}

public function shortcode_lista( $atts ) {
    // Parsear atributos con defaults
    $atts = shortcode_atts(
        array(
            'cantidad' => 5,
            'categoria' => '',
        ),
        $atts,
        'tienwi_lista'
    );

    // Sanitizar
    $cantidad  = absint( $atts['cantidad'] );
    $categoria = sanitize_text_field( $atts['categoria'] );

    // Capturar output (nunca hacer echo directo en shortcodes)
    ob_start();
    // ... renderizar HTML ...
    return ob_get_clean();
}
```

---

## Sanitización y validación (CRÍTICO)

```php
// Inputs de texto
$nombre = sanitize_text_field( $_POST['nombre'] ?? '' );

// Emails
$email = sanitize_email( $_POST['email'] ?? '' );

// URLs
$url = esc_url_raw( $_POST['url'] ?? '' );

// Enteros
$id = absint( $_POST['id'] ?? 0 );

// HTML permitido (ej: comentarios)
$contenido = wp_kses_post( $_POST['contenido'] ?? '' );

// Nonces (seguridad en formularios)
if ( ! wp_verify_nonce( $_POST['_wpnonce'] ?? '', 'tienwi_accion' ) ) {
    wp_die( 'Acción no autorizada' );
}

// Queries a la BD
global $wpdb;
$resultado = $wpdb->get_results(
    $wpdb->prepare(
        "SELECT * FROM {$wpdb->posts} WHERE ID = %d AND post_status = %s",
        $id,
        'publish'
    )
);
```

---

## Hooks de activación/desactivación

```php
register_activation_hook( __FILE__, 'tienwi_activar_plugin' );
register_deactivation_hook( __FILE__, 'tienwi_desactivar_plugin' );

function tienwi_activar_plugin() {
    // Crear tablas, opciones por defecto, flush rewrite rules
    tienwi_crear_tablas();
    add_option( 'tienwi_version', TIENWI_PLUGIN_VERSION );
    flush_rewrite_rules();
}

function tienwi_desactivar_plugin() {
    flush_rewrite_rules();
}

function tienwi_crear_tablas() {
    global $wpdb;
    $charset_collate = $wpdb->get_charset_collate();
    $tabla = $wpdb->prefix . 'tienwi_datos';

    $sql = "CREATE TABLE IF NOT EXISTS $tabla (
        id bigint(20) NOT NULL AUTO_INCREMENT,
        usuario_id bigint(20) NOT NULL,
        valor varchar(255) NOT NULL,
        creado_en datetime DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id)
    ) $charset_collate;";

    require_once ABSPATH . 'wp-admin/includes/upgrade.php';
    dbDelta( $sql );
}
```

---

## Páginas de administración

```php
public function registrar_menu_admin() {
    add_menu_page(
        __( 'Tienwi Plugin', 'tienwi-plugin' ), // Título página
        __( 'Tienwi', 'tienwi-plugin' ),         // Título menú
        'manage_options',                          // Capacidad requerida
        'tienwi-plugin',                           // Slug
        array( $this, 'render_pagina_admin' ),     // Callback
        'dashicons-store',                         // Icono
        25                                         // Posición
    );
}

public function render_pagina_admin() {
    if ( ! current_user_can( 'manage_options' ) ) {
        return;
    }
    // Cargar vista
    include TIENWI_PLUGIN_DIR . 'admin/views/main.php';
}

// Guardar opciones con Settings API
public function registrar_opciones() {
    register_setting( 'tienwi_opciones_grupo', 'tienwi_api_key', array(
        'sanitize_callback' => 'sanitize_text_field',
        'default'           => '',
    ) );

    add_settings_section(
        'tienwi_seccion_api',
        __( 'Configuración API', 'tienwi-plugin' ),
        null,
        'tienwi-plugin'
    );

    add_settings_field(
        'tienwi_api_key',
        __( 'API Key', 'tienwi-plugin' ),
        array( $this, 'render_campo_api_key' ),
        'tienwi-plugin',
        'tienwi_seccion_api'
    );
}
```

---

## AJAX seguro

```php
// Registrar handlers
add_action( 'wp_ajax_tienwi_accion', array( $this, 'handle_ajax' ) );
add_action( 'wp_ajax_nopriv_tienwi_accion', array( $this, 'handle_ajax' ) ); // Para no logueados

// Pasar nonce al JS
wp_localize_script( 'tienwi-plugin-script', 'tienwiAjax', array(
    'ajaxurl' => admin_url( 'admin-ajax.php' ),
    'nonce'   => wp_create_nonce( 'tienwi_ajax_nonce' ),
) );

public function handle_ajax() {
    // Validar nonce
    check_ajax_referer( 'tienwi_ajax_nonce', 'nonce' );

    // Validar capacidades si aplica
    if ( ! current_user_can( 'edit_posts' ) ) {
        wp_send_json_error( array( 'mensaje' => 'Sin permisos' ), 403 );
    }

    $dato = sanitize_text_field( $_POST['dato'] ?? '' );

    // Procesar...

    wp_send_json_success( array( 'resultado' => $dato ) );
}
```

---

## Checklist antes de entregar un plugin

- [ ] Header del plugin completo y correcto
- [ ] `if ( ! defined( 'ABSPATH' ) ) exit;` en cada archivo PHP
- [ ] Todos los inputs sanitizados/validados
- [ ] Nonces en todos los formularios y AJAX
- [ ] Queries con `$wpdb->prepare()`
- [ ] Scripts/estilos encolados con `wp_enqueue_*`
- [ ] Sin llamadas directas a `echo` en shortcodes (usar `ob_start`)
- [ ] Prefijo único en funciones, clases, opciones y tablas (`tienwi_`)
- [ ] Probado con `WP_DEBUG` activo sin errores ni notices
