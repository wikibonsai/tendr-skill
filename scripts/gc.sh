#!/bin/bash
# scripts/gc.sh — deterministic cleanup step (NOT a standalone compaction hook).
# Invoked by the tendr-gc sub-agent as the FINAL step of a consolidation pass.
# A shell hook cannot run the LLM consolidation pass — only the sub-agent can;
# this script just runs the deterministic checks after the sub-agent's tendr-cli
# mutations are done.
# No `set -e`: a non-zero `tendr doctor` on a messy garden must not abort cleanup.

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

# Final health check (non-fatal — report issues, don't abort)
tendr doctor || true

# Refresh tree view
tendr tree

# Log
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo -e "\n## ${TIMESTAMP} — gc pass complete\n" >> log-gc.md

echo "gc cleanup finished"
