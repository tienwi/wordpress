---
name: design-entregas
description: Estándares de entrega de diseño en Tienwi. Úsalo cuando necesites saber los tamaños correctos para redes sociales, formatos de exportación para web o desarrollo, especificaciones para Elkys, o cómo organizar archivos Figma para entregar a Mario/Miguel.
---

# Design Entregas — Tienwi Agency

Guía de especificaciones y flujos de entrega para el equipo de diseño.

---

## Tamaños por plataforma

### Instagram
| Formato | Tamaño | Notas |
|---|---|---|
| Post cuadrado | 1080×1080px | Formato más seguro |
| Post vertical | 1080×1350px | Mayor visibilidad en feed |
| Stories / Reels | 1080×1920px | Zona segura: 1080×1420px centro |
| Carrusel | 1080×1080px | Hasta 10 slides |

### Facebook
| Formato | Tamaño | Notas |
|---|---|---|
| Post | 1200×630px | O cuadrado 1080×1080 |
| Portada | 820×312px | Móvil recorta los lados |
| Ad imagen | 1200×628px | Mínimo texto |

### TikTok
| Formato | Tamaño |
|---|---|
| Video | 1080×1920px (9:16) |
| Imagen / carousel | 1080×1920px |

### Google Ads (Display)
| Formato | Tamaño |
|---|---|
| Leaderboard | 728×90px |
| Medium Rectangle | 300×250px |
| Large Rectangle | 336×280px |
| Half Page | 300×600px |
| Billboard | 970×250px |

---

## Exportación para web (WordPress / Shopify)

### Imágenes de producto
- **Formato:** WebP (con fallback JPG)
- **Resolución:** mínimo 1000×1000px (cuadrado para Shopify)
- **Peso máximo:** 200KB por imagen
- **Fondo:** blanco puro `#ffffff` o transparente (PNG)

### Hero / Banners
- **Desktop:** 1440×600px o 1920×800px
- **Móvil:** 768×500px o 390×600px (vertical)
- **Formato:** WebP
- **Peso máximo:** 150KB

### Logos
- **Entregables siempre:** SVG + PNG transparente + PNG blanco
- **Tamaños PNG:** 200px, 400px, 800px de ancho

### Íconos
- **Formato:** SVG siempre
- **Fallback:** PNG 2x (doble resolución para retina)

---

## Organización de archivos Figma

```
Proyecto [CLIENTE] /
├── 01 - Brief y Referencias
├── 02 - Identidad (logos, paleta, tipografía)
├── 03 - Web
│   ├── Desktop
│   └── Móvil
├── 04 - Redes Sociales
│   ├── Feed
│   └── Stories
├── 05 - Ads
│   ├── Meta
│   └── Google Display
└── 06 - Entregados ✓
```

**Nomenclatura de frames:** `[sección]-[nombre]-[estado]`
Ejemplo: `home-hero-v2-aprobado`

---

## Checklist de entrega a desarrollo (Mario / Miguel)

Antes de pasar un diseño a WordPress o Shopify:

- [ ] Todos los textos son editables (no rasterizados)
- [ ] Las fuentes están especificadas con nombre y peso
- [ ] Los colores tienen su código HEX/RGB anotado
- [ ] Los íconos están exportados como SVG sueltos
- [ ] Las imágenes están en la resolución correcta
- [ ] Se indicó qué elementos son dinámicos (vienen de base de datos)
- [ ] Hay versión móvil para cada sección
- [ ] El archivo Figma tiene acceso de "Viewer" compartido

---

## Checklist de entrega a Ads (Alexa)

- [ ] Formato correcto por plataforma (ver tabla arriba)
- [ ] Versión con y sin texto (para pruebas A/B)
- [ ] Archivos PNG/JPG + video MP4 si aplica
- [ ] Peso dentro de los límites de cada plataforma
- [ ] Variaciones de color si se solicitan

---

## Paleta y tipografía por defecto Tienwi

*(Actualizar con la identidad real de cada cliente)*

Solicitar a Iván o Hernando el brand kit del cliente antes de empezar.
Guardar en `.claude/memory/clientes.md` las notas de marca de cada cliente activo.

---

## Herramientas del equipo

| Herramienta | Para qué |
|---|---|
| **Figma** | UI/UX, mockups, sistemas de diseño |
| **Canva** | Piezas rápidas de redes sociales |
| **Midjourney / DALL-E** | Imágenes generativas, mockups de producto |
| **Adobe Photoshop** | Retoque y composición avanzada |
| **Adobe Illustrator** | Vectores, logotipos, íconos complejos |
| **Squoosh / TinyPNG** | Optimización de imágenes para web |
