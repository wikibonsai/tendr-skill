#!/bin/bash
# Discover the garden and print the semantic tree.
# Usage: load.sh [/path/to/garden]
# Also respects TENDR_DIR env var.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
bash "$SCRIPT_DIR/preflight.sh" || exit $?

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

cd "$GARDEN_DIR" || exit 0

# Model- and harness-agnostic kick-off directive: injected into context at session
# start so the agent enters the tendr workflow instead of waiting to be reminded.
echo "🪴 tendr garden loaded — this is your long-term semantic memory ($GARDEN_DIR)."
echo "Before asserting a fact, check the garden: 'tendr stat <node>'. Capture new knowledge with tendr-cli (add / graft / connect). Current semantic tree:"
echo ""
tendr tree 2>/dev/null
