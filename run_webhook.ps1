# Avvia il server webhook dell'agente (Windows PowerShell).
# Uso: .\run_webhook.ps1
#
# Variabili d'ambiente opzionali:
#   WEBHOOK_PORT   (default 8000)
#   WEBHOOK_TOKEN  (se impostato, abilita l'autenticazione Bearer)

$ErrorActionPreference = "Stop"

if (-not $env:WEBHOOK_PORT) { $env:WEBHOOK_PORT = "8000" }

Write-Host "Avvio webhook agente su porta $env:WEBHOOK_PORT ..." -ForegroundColor Cyan
if ($env:WEBHOOK_TOKEN) {
    Write-Host "Autenticazione: ABILITATA (Bearer token)" -ForegroundColor Green
} else {
    Write-Host "Autenticazione: DISABILITATA (solo test locale)" -ForegroundColor Yellow
}

python -m uvicorn src.adf_agent.webhook.server:app --host 0.0.0.0 --port $env:WEBHOOK_PORT --reload
