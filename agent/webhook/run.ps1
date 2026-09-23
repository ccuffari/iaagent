# Avvia il webhook server in locale (Windows PowerShell)

$env:WEBHOOK_PORT = if ($env:WEBHOOK_PORT) { $env:WEBHOOK_PORT } else { "8000" }
$env:AGENT_AUTO_DIAGNOSE = if ($env:AGENT_AUTO_DIAGNOSE) { $env:AGENT_AUTO_DIAGNOSE } else { "true" }

Write-Host "Avvio webhook server su porta $env:WEBHOOK_PORT..." -ForegroundColor Cyan

python server.py
