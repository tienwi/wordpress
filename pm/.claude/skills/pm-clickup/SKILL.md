---
name: pm-clickup
description: Gestión de proyectos Tienwi con ClickUp MCP. Úsalo cuando necesites consultar tareas, crear tickets, actualizar estados, asignar responsables, revisar el backlog de un cliente, o generar reportes de avance del equipo.
---

# PM ClickUp — Tienwi Agency

Guía para usar el MCP de ClickUp en la gestión de proyectos de la agencia.

---

## Configuración

El MCP de ClickUp está conectado vía **claude.ai connectors** (OAuth). No requiere `.mcp.json` local.
Se activa automáticamente en sesiones de Claude Code conectadas a tu cuenta de claude.ai.

---

## Workspace Tienwi

**Workspace ID:** `9011447394`

---

## Estructura real del workspace

```
TIENWI (space: 90112115690)
├── EQUIPO (folder: 90113676229)
│   ├── Hernando contreras     (list: 901113049242)
│   ├── Mario Andres           (list: 901106404749)
│   ├── Elkys Villasmil        (list: 901106404807)
│   ├── Miguel Andres          (list: 901110097246)
│   ├── Herramientas           (list: 901109784033)
│   ├── Videollamadas resumen  (list: 901110518972)
│   └── Tareas Whatsapp        (list: 901110526009)
│
├── GESTION CLIENTES (folder: 90113847245)
│   ├── Bitacora Comfacundi    (list: 901106671594)
│   ├── CLIENTES FEE           (list: 901113394059)
│   └── PROYECTOS ACTIVOS      (list: 901113398348)  ← principal
│
├── PROCESOS (folder: 90113731044)
│   ├── Biblioteca de Plantillas       (list: 901110372307)
│   ├── Biblioteca de Bloques          (list: 901110372403)
│   ├── PLATAFORMAS                    (list: 901111312283)
│   └── Errores Comunes                (list: 901112026529)
│
├── CURSOS, TUTORIALES Y GUIAS (folder: 90113761622)
├── KPIS                       (folder: 90117478299)
└── ARCHIVADO                  (folder: 90117782316)

TRAFICO TIENWI / OBICUA (space: 90112119766)
├── CLIENTES (folder: 90113676627)
│   ├── Accesos Clientes       (list: 901106490080)
│   └── Cronograma             (list: 901112122255)
└── Trafico web                (list: 901106155501)
```

---

## IDs del equipo Tienwi

| Persona | ID ClickUp | Email |
|---|---|---|
| Iván Rodríguez | `114010971` | ivan@tienwi.com.co |
| Hernando contreras | `87340402` | ejecutivocuenta@tienwi.com.co |
| Mario Andres Carreño | `270660605` | marioandresc87@gmail.com |
| Miguel Andrés carvajal | `81540041` | guitarraandres25@gmail.com |
| elkys villasmil | `270660704` | elkysv@gmail.com |
| Alexandra Mantilla (Alexa) | `270660709` | mercadeotienwi@gmail.com |

---

## Operaciones principales

### Ver proyectos activos del equipo

```
Usa clickup_filter_tasks con:
- list_id: "901113398348"   (PROYECTOS ACTIVOS)
- assignees: [id del miembro]
```

### Ver tareas de una persona

```
Usa clickup_filter_tasks con:
- list_id de su lista personal en EQUIPO
  - Hernando: 901113049242
  - Mario:    901106404749
  - Elkys:    901106404807
  - Miguel:   901110097246
```

### Crear nueva tarea en PROYECTOS ACTIVOS

```
clickup_create_task:
- list_id: "901113398348"
- name: "[CLIENTE] — Descripción breve"
- assignees: [id del responsable]
- due_date: timestamp en ms (ej: Date.now() + 7 días)
- description: contexto completo de la tarea
```

### Actualizar estado de tarea

```
clickup_update_task:
- task_id: "id de la tarea"
- status: "to do" | "in progress" | "review" | "complete"
```

### Buscar tarea por nombre

```
clickup_search:
- query: "nombre del cliente o tarea"
- space_ids: ["90112115690"]
```

---

## Flujo de reporte semanal

```
1. clickup_filter_tasks → PROYECTOS ACTIVOS → ordenar por fecha
2. Agrupar por estado: En progreso / Bloqueado / Completado esta semana
3. Por cada bloqueado: revisar comentarios con clickup_get_task_comments
4. Generar resumen para Iván/Hernando
```

---

## Patrones de tareas por vertical

```
[COMFACUNDI] — Ajuste de checkout WooCommerce     → asignar a Mario o Miguel
[SIOBIKE]    — Configurar carrito abandonado n8n   → asignar a Iván
[AMARA]      — Diseño de landing servicios         → asignar a Elkys
```

---

## Buenas prácticas

- **Títulos accionables**: empezar con verbo + cliente entre corchetes
- **Descripción con URL**: incluir siempre el sitio/recurso relevante
- **Fecha límite siempre**: aunque sea tentativa
- **Actualizar estado en cada sesión**: si se trabajó en algo, mover el estado
- **Bloqueos visibles**: cambiar a "blocked" con comentario explicando el bloqueo
- **Tareas Whatsapp**: usar lista `901110526009` para tareas que lleguen por WhatsApp
