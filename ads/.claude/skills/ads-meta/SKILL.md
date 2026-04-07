---
name: ads-meta
description: Gestión de campañas en Meta Ads (Facebook e Instagram) para Tienwi. Úsalo cuando necesites estructurar una campaña, escribir copies, definir audiencias, interpretar métricas, optimizar presupuesto, o diagnosticar bajo rendimiento en Meta Business Manager.
---

# Meta Ads — Tienwi Agency

Guía para crear y optimizar campañas en Meta para los clientes de la agencia.

---

## Estructura de campaña

```
Campaña (objetivo + presupuesto total)
└── Conjunto de anuncios (audiencia + presupuesto diario + placement)
    └── Anuncio (creatividad + copy + CTA)
```

**Regla:** una audiencia por conjunto, una variable por prueba.

---

## Objetivos de campaña por tipo de cliente

| Objetivo | Cuándo usarlo |
|---|---|
| **Ventas** | Tiendas WooCommerce/Shopify con píxel configurado |
| **Tráfico** | Llevar visitas a una landing page |
| **Interacción** | Aumentar seguidores / engagement |
| **Leads** | Formulario nativo de Meta para captar contactos |
| **Reconocimiento** | Lanzamiento de marca, no para conversión directa |

---

## Estructura de audiencias por etapa del funnel

### TOFU — Top of Funnel (Frío)
```
- Intereses relacionados con el producto/servicio
- Comportamientos de compra online
- Segmentación demográfica amplia (Colombia, 25-45 años)
- LAL (Lookalike) 2-5% de clientes actuales
```

### MOFU — Middle of Funnel (Tibio)
```
- Visitantes del sitio web (últimos 30-60 días)
- Personas que vieron el 50%+ de un video
- Engagement con la página de Instagram/Facebook
- Abandonaron el carrito (WooCommerce/Shopify)
```

### BOFU — Bottom of Funnel (Caliente)
```
- Visitantes de página de producto (últimos 14 días)
- Compradores anteriores (LAL 1%)
- Lista de clientes subida como audiencia personalizada
```

---

## Copies — estructura efectiva

### Para ecommerce (venta directa)
```
GANCHO (1-2 líneas): Problema o deseo del cliente
BENEFICIO: Por qué este producto/servicio lo resuelve
PRUEBA SOCIAL: Resultado, reseña o número concreto
CTA: "Compra ahora" / "Ver oferta" / "Envío gratis hoy"
```

### Para captación de leads
```
PREGUNTA: ¿Estás buscando [resultado deseado]?
PROPUESTA: Nosotros te ayudamos con [solución]
URGENCIA: Solo para [ciudad] / Plazas limitadas
CTA: "Quiero más info" / "Me interesa"
```

---

## Métricas clave y valores de referencia (Colombia)

| Métrica | Bueno | Alerta | Mal |
|---|---|---|---|
| CTR (Link) | > 2% | 1-2% | < 1% |
| CPM | < $12.000 COP | $12-20K | > $20.000 COP |
| CPC | < $500 COP | $500-1.000 | > $1.000 COP |
| ROAS ecommerce | > 3x | 2-3x | < 2x |
| Frecuencia | < 3 | 3-4 | > 4 |
| Relevance Score | 7-10 | 4-6 | 1-3 |

---

## Diagnóstico de campaña de bajo rendimiento

```
1. ¿CTR bajo? → Problema en la creatividad o el copy
2. ¿CPM alto? → Audiencia demasiado pequeña o muy competida
3. ¿Clics pero sin conversiones? → Landing page o precio
4. ¿Frecuencia > 4? → Renovar creatividades o ampliar audiencia
5. ¿ROAS < 2x? → Revisar segmentación + oferta + precio del producto
```

---

## Checklist antes de lanzar una campaña

- [ ] Píxel de Meta instalado y verificado en el sitio
- [ ] Evento de conversión configurado (Purchase, Lead, etc.)
- [ ] Creatividades aprobadas (por cliente y por Meta)
- [ ] Copy revisado (sin palabras prohibidas por Meta)
- [ ] UTM configurados en la URL de destino
- [ ] Presupuesto diario definido
- [ ] Fecha de inicio y fin establecidas
- [ ] Audiencia de remarketing excluida de campañas frías

---

## UTM estándar Tienwi

```
utm_source=facebook
utm_medium=cpc
utm_campaign=[nombre-cliente]-[objetivo]-[fecha]
utm_content=[nombre-creatividad]
utm_term=[audiencia]

Ejemplo:
?utm_source=facebook&utm_medium=cpc&utm_campaign=comfacundi-ventas-abr26&utm_content=banner-descuento&utm_term=remarketing
```

---

## Palabras prohibidas en Meta Ads (evitar)

- Referencias a características personales: "¿Eres diabético?"
- Lenguaje de urgencia extrema: "¡ÚLTIMA OPORTUNIDAD!"
- Afirmaciones de salud: "Cura", "Trata", "Elimina"
- Antes/después implícito en imágenes de cuerpo
- Garantías absolutas: "100% garantizado"

---

## Presupuestos mínimos recomendados (Colombia)

| Objetivo | Mínimo diario | Para ver resultados |
|---|---|---|
| Ventas (ecommerce) | $30.000 COP | 7-10 días |
| Tráfico | $15.000 COP | 5-7 días |
| Leads | $20.000 COP | 5-7 días |
| Reconocimiento | $10.000 COP | 7 días |
