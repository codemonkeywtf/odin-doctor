#!/bin/bash
set -euo pipefail

# docker-run.sh — Quick launcher for odin-doctor dev container
# Rebuilds only when Dockerfile or compose changes (or force with --no-cache)

cd "$(dirname "$0")"

# Optional: force rebuild with ./docker-run.sh --no-cache
if [[ "${1:-}" == "--no-cache" ]]; then
    echo "Building with --no-cache..."
    docker compose build --no-cache
else
    docker compose build --quiet || true  # quiet, only rebuild if needed
fi

echo "Starting dev container (non-root user)..."
docker compose run --rm dev
