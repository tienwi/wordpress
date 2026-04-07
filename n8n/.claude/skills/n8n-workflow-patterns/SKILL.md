---
name: n8n-workflow-patterns
description: Patrones de workflows n8n para Tienwi. Úsalo cuando necesites construir automatizaciones con WooCommerce, Shopify, HighLevel, ClickUp o WhatsApp; escribir expresiones n8n; manejar errores; procesar webhooks; o estructurar flujos complejos con bifurcaciones y merges.
---

# N8N Workflow Patterns — Tienwi Agency

Patrones reutilizables para los flujos de automatización de la agencia.

---

## Estructura base de todo workflow

```
[Trigger] → [Validar entrada] → [Lógica principal] → [Acciones] → [Error Handler]
```

**Regla:** siempre un nodo de error handler en flujos que tocan producción.

---

## Patrón 1: Webhook de WooCommerce → Notificación equipo

**Caso de uso:** Notificar al equipo cuando hay un pedido nuevo.

```
Webhook (POST /woo-pedido) 
  → IF: order_status == "processing"
  → Set: formatear datos del pedido
  → HTTP Request: POST a WhatsApp Business API
  → ClickUp: crear tarea en lista PROYECTOS ACTIVOS
```

**Nodo Set para formatear:**
```javascript
{
  "cliente": "{{ $json.billing.first_name }} {{ $json.billing.last_name }}",
  "total": "{{ $json.total | currency }}",
  "productos": "{{ $json.line_items.map(i => i.name).join(', ') }}",
  "fecha": "{{ DateTime.now().setZone('America/Bogota').toFormat('dd/MM/yyyy HH:mm') }}"
}
```

---

## Patrón 2: Shopify → HighLevel (nuevo cliente)

**Caso de uso:** Agregar cliente de Shopify a HighLevel como contacto/lead.

```
Webhook (Shopify: customers/create)
  → Set: mapear campos Shopify → HighLevel
  → HTTP Request: POST /contacts a HighLevel API
  → IF: error → Slack/WhatsApp al equipo
```

**Mapeo de campos:**
```javascript
{
  "firstName": "{{ $json.first_name }}",
  "lastName": "{{ $json.last_name }}",
  "email": "{{ $json.email }}",
  "phone": "{{ $json.phone }}",
  "source": "Shopify",
  "tags": ["cliente-shopify", "{{ $json.tags }}"]
}
```

---

## Patrón 3: Schedule → Reporte ClickUp → WhatsApp

**Caso de uso:** Reporte diario de tareas del equipo cada lunes 8am.

```
Schedule (Lunes 8:00am Colombia)
  → ClickUp: filter_tasks (PROYECTOS ACTIVOS, status=in progress)
  → Code: formatear resumen
  → WhatsApp: enviar a grupo del equipo
```

**Nodo Code para formato:**
```javascript
const tasks = $input.all();
const resumen = tasks.map(t => `• ${t.json.name} → ${t.json.assignees[0]?.username || 'Sin asignar'}`).join('\n');
return [{ json: { mensaje: `*Tareas activas hoy:*\n${resumen}` } }];
```

---

## Patrón 4: Error Handler universal

Agregar siempre al final de workflows críticos:

```
[Error Trigger]
  → Set: preparar mensaje de error
  → WhatsApp/Telegram: notificar a Iván
```

**Mensaje de error estándar:**
```javascript
{
  "texto": "❌ Error en workflow: {{ $workflow.name }}\nNodo: {{ $execution.error.node.name }}\nMensaje: {{ $execution.error.message }}\nFecha: {{ DateTime.now().setZone('America/Bogota').toFormat('dd/MM/yyyy HH:mm') }}"
}
```

---

## Expresiones n8n frecuentes

```javascript
// Fecha y hora en Colombia
{{ DateTime.now().setZone('America/Bogota').toFormat('dd/MM/yyyy HH:mm') }}

// Solo fecha
{{ DateTime.now().setZone('America/Bogota').toFormat('dd/MM/yyyy') }}

// Primer item del array
{{ $json.items[0].name }}

// Concatenar nombre completo
{{ $json.first_name + ' ' + $json.last_name }}

// Precio formateado COP
{{ Number($json.price).toLocaleString('es-CO', {style: 'currency', currency: 'COP'}) }}

// Verificar si campo existe
{{ $json.phone ? $json.phone : 'Sin teléfono' }}

// Datos del nodo anterior
{{ $node["Nombre del Nodo"].json.campo }}

// Iterar array en expresión
{{ $json.items.map(i => i.name).join(', ') }}
```

---

## Integraciones habituales Tienwi

### WooCommerce
- **Auth:** Application Password (usuario + contraseña de app)
- **Base URL:** `https://tienda.cliente.com/wp-json/wc/v3`
- **Webhook events útiles:** `order.created`, `order.status_changed`, `product.updated`

### Shopify
- **Auth:** Admin API token (`X-Shopify-Access-Token`)
- **Base URL:** `https://tienda.myshopify.com/admin/api/2024-01`
- **Webhook events útiles:** `orders/create`, `customers/create`, `inventory_levels/update`

### HighLevel
- **Auth:** Bearer token (API Key de la sub-cuenta)
- **Base URL:** `https://rest.gohighlevel.com/v1`
- **Endpoints frecuentes:** `/contacts`, `/opportunities`, `/conversations/messages`

### ClickUp
- **Auth:** Bearer token (Personal Token de Iván)
- **Workspace ID:** `9011447394`
- **Lista PROYECTOS ACTIVOS:** `901113398348`

---

## Reglas Tienwi para n8n

- **Nombrar nodos claramente:** "Validar pedido" no "IF1"
- **Sticky Notes** en cada sección del flujo para documentar
- **Test antes de activar:** siempre ejecutar con datos reales en modo test
- **Credenciales en n8n Credentials**, nunca hardcodeadas en nodos Code
- **Versionado:** exportar el JSON del workflow al repo después de cada cambio importante
