---
name: shopify-liquid
description: Desarrollo de temas Shopify con Liquid para Tienwi. Úsalo cuando necesites crear secciones personalizadas, modificar templates, trabajar con metafields, construir bloques para el Theme Editor, o usar la Storefront API / Admin API desde el frontend.
---

# Shopify Liquid — Tienwi Agency

Guía para desarrollo de temas Shopify siguiendo los estándares de la agencia.

---

## Estructura de un tema Shopify

```
theme/
├── assets/          ← CSS, JS, imágenes, fuentes
├── config/
│   ├── settings_schema.json   ← Opciones globales del tema
│   └── settings_data.json     ← Valores actuales
├── layout/
│   └── theme.liquid           ← Plantilla base (head, header, footer)
├── sections/        ← Bloques reutilizables para el Theme Editor
├── snippets/        ← Fragmentos reutilizables con render
├── templates/       ← Una por tipo de página
│   ├── index.json
│   ├── product.json
│   ├── collection.json
│   └── page.json
└── locales/         ← Traducciones
```

---

## Crear una sección personalizada

```liquid
{% comment %} sections/tienwi-banner.liquid {% endcomment %}

<div class="tienwi-banner" style="background-color: {{ section.settings.bg_color }}">
  <h2>{{ section.settings.titulo }}</h2>
  <p>{{ section.settings.descripcion }}</p>
  {% if section.settings.boton_texto != blank %}
    <a href="{{ section.settings.boton_url }}" class="btn">
      {{ section.settings.boton_texto }}
    </a>
  {% endif %}
</div>

{% schema %}
{
  "name": "Banner Tienwi",
  "settings": [
    { "type": "text",  "id": "titulo",       "label": "Título",      "default": "Título del banner" },
    { "type": "textarea", "id": "descripcion", "label": "Descripción" },
    { "type": "color", "id": "bg_color",     "label": "Color fondo", "default": "#ffffff" },
    { "type": "text",  "id": "boton_texto",  "label": "Texto botón" },
    { "type": "url",   "id": "boton_url",    "label": "URL botón" }
  ],
  "presets": [{ "name": "Banner Tienwi" }]
}
{% endschema %}
```

---

## Metafields (Shopify 2.0+)

```liquid
{% comment %} Leer metafield de producto {% endcomment %}
{{ product.metafields.custom.ficha_tecnica }}

{% comment %} Metafield con tipo rich_text {% endcomment %}
{{ product.metafields.custom.descripcion_larga | metafield_tag }}

{% comment %} Metafield de imagen {% endcomment %}
{% assign img = product.metafields.custom.imagen_secundaria.value %}
<img src="{{ img | image_url: width: 800 }}" alt="{{ img.alt }}">
```

---

## Trabajar con productos y colecciones

```liquid
{% comment %} Iterar productos de una colección {% endcomment %}
{% for product in collection.products %}
  <div class="product-card">
    <a href="{{ product.url }}">
      {{ product.featured_image | image_url: width: 400 | image_tag: alt: product.title }}
      <h3>{{ product.title }}</h3>
      <p>{{ product.price | money }}</p>
    </a>
  </div>
{% endfor %}

{% comment %} Verificar si tiene descuento {% endcomment %}
{% if product.compare_at_price > product.price %}
  <span class="badge-sale">
    -{{ product.compare_at_price | minus: product.price | times: 100 | divided_by: product.compare_at_price }}%
  </span>
{% endif %}
```

---

## Enqueue de assets

```liquid
{% comment %} En layout/theme.liquid o en la sección {% endcomment %}
{{ 'tienwi-custom.css' | asset_url | stylesheet_tag }}
{{ 'tienwi-custom.js'  | asset_url | script_tag }}

{% comment %} JS con defer {% endcomment %}
<script src="{{ 'tienwi-custom.js' | asset_url }}" defer></script>
```

---

## Webhooks para n8n (desde Admin API)

Los webhooks de Shopify se configuran en Admin → Settings → Notifications o vía API:

**Eventos clave para automatizaciones Tienwi:**
- `orders/create` → Notificar al equipo, actualizar ClickUp
- `orders/fulfilled` → Email/WhatsApp al cliente
- `products/update` → Sincronizar con catálogo
- `customers/create` → Agregar a HighLevel como lead

**Endpoint n8n:** configurar en Shopify como webhook apuntando al webhook trigger de n8n.

---

## Shopify CLI — comandos frecuentes

```bash
# Conectar con la tienda
shopify theme dev --store=nombre-tienda.myshopify.com

# Subir tema completo
shopify theme push

# Descargar tema activo
shopify theme pull

# Listar temas
shopify theme list
```

---

## Reglas Tienwi para Shopify

- **Nunca editar el tema activo directamente** → duplicar primero
- **Prefijo `tienwi-`** en nombres de secciones, snippets y assets custom
- **Siempre probar en Preview** antes de publicar
- **Metafields** para datos extra de producto, nunca en descripciones con HTML hackeado
- Documentar cambios en `BITACORA.md` del proyecto
