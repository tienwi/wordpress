---
name: pm-clickup
description: Gestión de proyectos Tienwi con ClickUp MCP. Úsalo cuando necesites consultar tareas, crear tickets, actualizar estados, asignar responsables, revisar el backlog de un cliente, o generar reportes de avance del equipo.
---

# PM ClickUp — Tienwi Agency

Guía para usar el MCP de ClickUp en la gestión de proyectos de la agencia.

---

## Configuración

El MCP de ClickUp está configurado en `.mcp.json` de esta carpeta. Se activa automáticamente al abrir este agente en Claude Code.

---

## Operaciones principales

### Listar tareas activas del equipo

```
Consulta las tareas en progreso del equipo usando list_tasks.
Filtra por estado "in progress" o "en progreso".
```

### Crear una nueva tarea

```
Información mínima necesaria:
- Nombre de la tarea (claro y accionable)
- Lista/espacio destino (cliente o vertical)
- Responsable (miembro del equipo)
- Fecha límite (si aplica)
- Descripción con contexto suficiente
```

### Actualizar el estado de una tarea

```
Estados estándar Tienwi:
- "To Do" / "Por hacer"
- "In Progress" / "En progreso"
- "Review" / "En revisión"
- "Done" / "Completado"
- "Blocked" / "Bloqueado"
```

### Reportar estado por cliente

```
Para generar un reporte de cliente:
1. list_tasks filtrado por cliente/proyecto
2. Agrupar por estado
3. Identificar tareas vencidas
4. Listar bloqueos activos
5. Sugerir próximos pasos
```

---

## Estructura de espacios en ClickUp

```
Tienwi/
├── Clientes/
│   ├── Comfacundi
│   ├── SIOBIKE
│   └── Centro Estética Amara
├── Operaciones/
│   ├── Desarrollo Web
│   ├── Diseño
│   ├── Ads
│   └── Automatización
└── Interno/
    └── Agencia
```

---

## Patrones de tareas por vertical

### Desarrollo WordPress/Shopify
```
Título: [CLIENTE] — Descripción breve de la tarea
Asignar a: Mario Andrés o Miguel
Etiquetas: wordpress / shopify / woocommerce
```

### Diseño
```
Título: [CLIENTE] — Tipo de entregable
Asignar a: Elkys
Etiquetas: diseño / figma / gráfico
```

### Ads
```
Título: [CLIENTE] — Plataforma — Tipo de campaña
Asignar a: Alexa o Iván
Etiquetas: meta-ads / google-ads / tiktok-ads
```

### Automatización
```
Título: [CLIENTE] — Descripción del flujo
Asignar a: Iván
Etiquetas: n8n / highlevel / automatización
```

---

## Buenas prácticas

- **Títulos accionables**: empezar con verbo (Crear, Revisar, Entregar, Corregir)
- **Descripción con contexto**: incluir URL del sitio, cliente, y qué se espera
- **Fecha límite siempre**: aunque sea tentativa, ayuda al equipo a priorizar
- **Actualizar en cada sesión**: si trabajaste en algo, actualiza el estado
- **Bloqueos visibles**: cambiar a "Blocked" inmediatamente con comentario explicando el bloqueo
