#!/bin/bash
# Verify tendr-cli is installed and executable.
# Sources: call from other scripts via `source preflight.sh` or `bash preflight.sh`.
# Exit code 0 = ready, 1 = not ready (message printed to stdout).

if ! command -v tendr &>/dev/null; then
  echo "tendr-cli not found. Install with: npm install -g tendr-cli"
  exit 1
fi

if ! tendr --version &>/dev/null; then
  echo "tendr-cli found but not executable. Fix with: chmod +x $(readlink -f $(command -v tendr))"
  exit 1
fi
