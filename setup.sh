#!/bin/bash
# setup.sh — Tienwi WordPress Agent
# Ejecutar una vez al clonar el repo en un nuevo computador.
# Instala los skills del agente en ~/.claude/skills/

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SOURCE="$REPO_DIR/.claude/skills"
SKILLS_DEST="$HOME/.claude/skills"

echo "Instalando skills del agente WordPress Tienwi..."

# Crear directorio de skills si no existe
mkdir -p "$SKILLS_DEST"

# Copiar cada skill
for skill_dir in "$SKILLS_SOURCE"/*/; do
    skill_name=$(basename "$skill_dir")
    dest="$SKILLS_DEST/$skill_name"

    if [ -d "$dest" ]; then
        echo "  Actualizando: $skill_name"
        rm -rf "$dest"
    else
        echo "  Instalando:   $skill_name"
    fi

    cp -r "$skill_dir" "$dest"
done

echo ""
echo "Listo. Skills instalados en $SKILLS_DEST:"
ls "$SKILLS_DEST" | grep -E "wp-" | sed 's/^/  - /'
echo ""
echo "Puedes abrir el proyecto con Claude Code ahora."
