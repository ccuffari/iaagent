#!/usr/bin/env bash
# Avvia il server webhook dell'agente (Linux/macOS).
# Uso: ./run_webhook.sh
#
# Variabili d'ambiente opzionali:
#   WEBHOOK_PORT   (default 8000)
#   WEBHOOK_TOKEN  (se impostato, abilita l'autenticazione Bearer)

set -euo pipefail

: "${WEBHOOK_PORT:=8000}"
export WEBHOOK_PORT

echo "Avvio webhook agente su porta ${WEBHOOK_PORT} ..."
if [ -n "${WEBHOOK_TOKEN:-}" ]; then
  echo "Autenticazione: ABILITATA (Bearer token)"
else
  echo "Autenticazione: DISABILITATA (solo test locale)"
fi

python -m uvicorn src.adf_agent.webhook.server:app --host 0.0.0.0 --port "${WEBHOOK_PORT}" --reload
