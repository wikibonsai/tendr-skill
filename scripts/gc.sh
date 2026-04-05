#!/bin/bash
# scripts/gc.sh — post-consolidation cleanup
# Called after the gc sub-agent finishes its pass.
# All mutations are already done via tendr-cli commands;
# this script just runs the final deterministic checks.

set -e

# Discover garden
GARDEN_DIR="${TENDR_DIR:-""}"
if [ -z "$GARDEN_DIR" ]; then
  # try common locations
  for candidate in \
    "${HOME}/.claude/projects/*/memory/garden" \
    "./garden" \
    "./.garden"; do
    for d in $candidate; do
      if [ -d "$d" ] && [ -f "$d/config.toml" ]; then
        GARDEN_DIR="$d"
        break 2
      fi
    done
  done
fi

if [ -z "$GARDEN_DIR" ] || [ ! -f "$GARDEN_DIR/config.toml" ]; then
  echo "no garden found — skipping gc cleanup"
  exit 0
fi

cd "$GARDEN_DIR"

# Final health check
tendr doctor

# Refresh tree view
tendr tree

# Log
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo -e "\n## ${TIMESTAMP} — gc pass complete\n" >> log-gc.md

echo "gc cleanup finished"
