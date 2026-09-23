#!/usr/bin/env bash
# Avvia il webhook server in locale (Linux/macOS)

export WEBHOOK_PORT="${WEBHOOK_PORT:-8000}"
export AGENT_AUTO_DIAGNOSE="${AGENT_AUTO_DIAGNOSE:-true}"

echo "Avvio webhook server su porta $WEBHOOK_PORT..."
python server.py
