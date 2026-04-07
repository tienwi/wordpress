# Tienwi Agentes — Monorepo

Eres un agente de **Tienwi Agency**, una agencia colombiana especializada en ecommerce y automatización.

Este repositorio contiene todos los agentes del equipo. Cada subcarpeta es un agente independiente que se abre con Claude Code.

---

## Estructura del monorepo

```
tienwi/agentes/
├── wordpress/    → Agent WordPress Dev  (Mario, Miguel)
├── shopify/      → Agent Shopify Dev    (Mario, Miguel)
├── design/       → Agent Design         (Elkys)
├── ads/          → Agent Ads            (Alexa, Iván)
├── n8n/          → Agent N8N            (Iván)
├── highlevel/    → Agent HighLevel      (Iván)
└── pm/           → Agent PM ⭐          (Hernando, Iván) — núcleo
```

---

## Cómo usar cada agente

```bash
# Abrir el agente que necesitas con Claude Code
claude agentes/wordpress      # Mario y Miguel
claude agentes/shopify        # Mario y Miguel
claude agentes/design         # Elkys
claude agentes/ads            # Alexa e Iván
claude agentes/n8n            # Iván
claude agentes/highlevel      # Iván
claude agentes/pm             # Hernando e Iván
```

O desde VS Code/Cursor: abre la subcarpeta del agente.

---

## Memoria compartida

Los archivos de contexto global están en `.claude/memory/`:

- `.claude/memory/empresa.md` — Equipo, verticales, herramientas
- `.claude/memory/clientes.md` — Clientes activos (actualizar con el PM)
- `.claude/memory/decisiones.md` — Decisiones técnicas transversales

---

## Reglas globales

- El equipo habla en **español**. Responde siempre en español.
- Consulta antes de modificar archivos en producción.
- Consulta antes de eliminar datos.
- Consulta antes de cambiar credenciales o configuraciones críticas.

---

## Sincronización del equipo

```bash
git pull   # Al inicio del día → agentes actualizados
git push   # Al final de la sesión → cambios disponibles para todos
```

---

## Si estás en la raíz del repo

Navega a la carpeta del agente que necesitas. Cada agente tiene su propio `CLAUDE.md` con instrucciones detalladas y sus skills instalables.
