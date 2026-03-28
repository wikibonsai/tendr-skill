#!/bin/bash
# Discover the garden and print the semantic tree.
# Usage: load-tree.sh [/path/to/garden]
# Also respects TENDR_DIR env var.

GARDEN_DIR="${1:-$TENDR_DIR}"

# If no path provided, search common locations
if [ -z "$GARDEN_DIR" ] || [ ! -f "$GARDEN_DIR/config.toml" ]; then
  GARDEN_DIR=""
  for dir in $HOME/.claude/projects/*/memory/garden ./garden ./.garden; do
    if [ -f "$dir/config.toml" ]; then
      GARDEN_DIR="$dir"
      break
    fi
  done
fi

if [ -z "$GARDEN_DIR" ] || [ ! -f "$GARDEN_DIR/config.toml" ]; then
  echo "No garden found. Set TENDR_DIR or provide a path: /tendr /path/to/garden"
  exit 0
fi

cd "$GARDEN_DIR" && tendr tree 2>/dev/null
