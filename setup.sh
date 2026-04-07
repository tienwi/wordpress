#!/bin/bash
# setup.sh — Tienwi Agentes Monorepo
# Ejecutar una vez al clonar el repo en un nuevo computador.
# Instala los skills de todos los agentes en ~/.claude/skills/

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DEST="$HOME/.claude/skills"

echo "======================================"
echo "  Tienwi Agency — Setup de Agentes"
echo "======================================"
echo ""

# Crear directorio de skills global si no existe
mkdir -p "$SKILLS_DEST"

# Instalar skills de cada agente
AGENTS=("wordpress" "shopify" "design" "ads" "n8n" "highlevel" "pm")
TOTAL=0

for agent in "${AGENTS[@]}"; do
    SKILLS_SOURCE="$REPO_DIR/$agent/.claude/skills"

    if [ ! -d "$SKILLS_SOURCE" ]; then
        continue
    fi

    # Verificar si hay skills en esta carpeta
    skill_count=$(find "$SKILLS_SOURCE" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    if [ "$skill_count" -eq 0 ]; then
        continue
    fi

    echo "[$agent]"

    for skill_dir in "$SKILLS_SOURCE"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name=$(basename "$skill_dir")
        dest="$SKILLS_DEST/$skill_name"

        if [ -d "$dest" ]; then
            echo "  Actualizando: $skill_name"
            rm -rf "$dest"
        else
            echo "  Instalando:   $skill_name"
        fi

        cp -r "$skill_dir" "$dest"
        TOTAL=$((TOTAL + 1))
    done
done

echo ""
echo "======================================"
if [ "$TOTAL" -eq 0 ]; then
    echo "  Sin skills que instalar aún."
else
    echo "  $TOTAL skill(s) instalado(s) en $SKILLS_DEST"
    echo ""
    echo "  Skills disponibles:"
    ls "$SKILLS_DEST" 2>/dev/null | sed 's/^/    - /'
fi
echo ""
echo "  Cómo usar cada agente:"
echo "    claude wordpress/    # Mario y Miguel"
echo "    claude shopify/      # Mario y Miguel"
echo "    claude design/       # Elkys"
echo "    claude ads/          # Alexa e Iván"
echo "    claude n8n/          # Iván"
echo "    claude highlevel/    # Iván"
echo "    claude pm/           # Hernando e Iván"
echo ""
echo "  O abre la subcarpeta en VS Code / Cursor."
echo "======================================"
