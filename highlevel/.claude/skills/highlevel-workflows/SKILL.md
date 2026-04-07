---
name: highlevel-workflows
description: Automatizaciones y configuración de HighLevel (GoHighLevel) para Tienwi. Úsalo cuando necesites crear workflows de nurturing, configurar pipelines, enviar comunicaciones masivas, integrar con n8n, gestionar sub-cuentas de clientes, o diagnosticar problemas en el CRM.
---

# HighLevel Workflows — Tienwi Agency

Guía para configurar y automatizar HighLevel en la agencia.

---

## Estructura del workspace Tienwi en HighLevel

```
Agencia Tienwi (cuenta principal)
├── Sub-cuenta: Tienwi (interna — gestión de leads propios)
├── Sub-cuenta: Comfacundi
├── Sub-cuenta: SIOBIKE
└── Sub-cuenta: Centro Estética Amara
```

---

## Pipelines estándar

### Pipeline de ventas de la agencia
```
Lead Nuevo 
  → Contactado (primera llamada/mensaje)
  → Reunión Agendada
  → Propuesta Enviada
  → Negociación
  → ✅ Cerrado Ganado
  → ❌ Cerrado Perdido
```

### Pipeline de entrega de proyectos
```
Kickoff Realizado
  → En Desarrollo
  → En Revisión Cliente
  → Correcciones
  → ✅ Entregado
  → Soporte Activo
```

---

## Patrón: Workflow de bienvenida a nuevo lead

**Trigger:** Lead entra por formulario o ad
**Objetivo:** Contactar en menos de 5 minutos

```
Trigger: Form Submitted / Facebook Lead Ad
  → Wait: 2 minutos
  → Send SMS: "Hola {{ contact.first_name }}, recibimos tu solicitud. ¿Tienes 5 min para hablar?"
  → Wait: 1 hora
  → IF: responded == No
    → Send Email: email de seguimiento con propuesta de valor
  → IF: responded == Yes
    → Notify internal: "Lead caliente listo para llamada" → Hernando
    → Update opportunity stage: "Contactado"
```

---

## Patrón: Secuencia de nurturing (7 días)

Para leads que no convirtieron de inmediato:

```
Día 0: Email bienvenida + recurso gratuito (PDF, guía)
Día 1: WhatsApp: caso de éxito relevante
Día 3: Email: beneficios específicos para su industria
Día 5: SMS: "¿Pudiste revisar la info? ¿Tienes dudas?"
Día 7: Email: oferta con urgencia real (descuento, bono, fecha límite)
```

---

## Configuración de comunicaciones

### Email
- **From Name:** `Tienwi Agency` o nombre de la sub-cuenta
- **From Email:** usar dominio propio autenticado (SPF, DKIM, DMARC)
- **Evitar:** Gmail/Hotmail como from email para campañas masivas

### WhatsApp Business
- Conectar número de WhatsApp Business verificado
- Templates pre-aprobados por Meta para mensajes outbound
- Mensajes libres solo dentro de la ventana de 24h de conversación activa

### SMS
- Verificar disponibilidad en Colombia (operador A2P)
- Incluir siempre opción de opt-out: "Responde STOP para no recibir más mensajes"

---

## Integración HighLevel ↔ n8n

### Webhook desde HighLevel a n8n
En HighLevel Workflow → Add Action → Webhook:
```
URL: https://tu-n8n.com/webhook/highlevel-evento
Method: POST
Body: {{ contact.toJSON() }}
```

### Desde n8n a HighLevel (crear/actualizar contacto)
```
HTTP Request:
  Method: POST
  URL: https://rest.gohighlevel.com/v1/contacts/
  Headers:
    Authorization: Bearer {{ $credentials.highlevel_api_key }}
    Content-Type: application/json
  Body:
    firstName: {{ $json.nombre }}
    email: {{ $json.email }}
    phone: {{ $json.telefono }}
    source: "n8n - WooCommerce"
```

---

## Checklist para nueva sub-cuenta de cliente

- [ ] Crear sub-cuenta con nombre del cliente
- [ ] Configurar timezone: America/Bogota
- [ ] Agregar dominio personalizado (si aplica)
- [ ] Configurar email sending domain (SPF/DKIM)
- [ ] Conectar número de WhatsApp Business
- [ ] Importar snapshot base de la agencia
- [ ] Crear pipeline según tipo de cliente
- [ ] Agregar usuarios del cliente con permisos limitados
- [ ] Configurar fuentes de leads (formularios, Meta, Google)
- [ ] Activar workflow de bienvenida y nurturing

---

## Buenas prácticas Tienwi

- **Nunca enviar masivos sin lista limpia:** verificar emails antes de campañas grandes
- **Opt-in confirmado:** todo lead debe haber dado consentimiento explícito
- **Tags siempre:** etiquetar leads por fuente, producto de interés y etapa
- **Un workflow por objetivo:** no hacer workflows "todo en uno" difíciles de debuggear
- **Documentar en ClickUp** cualquier cambio de configuración en sub-cuentas de clientes
- **Respetar Ley 1581 Colombia:** manejo de datos personales con consentimiento

---

## Límites y cuotas a tener en cuenta

| Recurso | Límite típico |
|---|---|
| Emails por mes | Según plan (verificar con Iván) |
| SMS Colombia | Tarifa por mensaje, confirmar con proveedor |
| WhatsApp outbound | Solo con templates aprobados por Meta |
| Sub-cuentas | Según plan de agencia |
| Contactos por sub-cuenta | Sin límite en plan SaaS |
