# Webhook Agente — Fase 2

Server FastAPI che riceve gli alert di **Azure Monitor** e avvia la diagnosi dell'agente.

## Architettura

```
Azure Monitor (alert) --> Action Group (webhook) --> Cloudflare Tunnel
    --> Agente locale (FastAPI) --> diagnosi + proposta remediation
```

## Endpoint

| Metodo | Path | Scopo |
|--------|------|-------|
| GET | `/health` | Health check (per Cloudflare Tunnel) |
| POST | `/webhook/azure-alert` | Riceve il payload di Azure Monitor |
| POST | `/webhook/test` | Endpoint di test con payload finto |

## Setup

### 1. Installa le dipendenze

```bash
pip install -r requirements-webhook.txt
```

### 2. Avvia il server

**Windows (PowerShell):**
```powershell
$env:WEBHOOK_TOKEN = "il-tuo-token-segreto"
.\run_webhook.ps1
```

**Linux/macOS:**
```bash
export WEBHOOK_TOKEN="il-tuo-token-segreto"
./run_webhook.sh
```

Il server ascolta su `http://localhost:8000` (configurabile con `WEBHOOK_PORT`).

### 3. Esponi con Cloudflare Tunnel

```bash
cloudflared tunnel --url http://localhost:8000
```

Ottieni un URL pubblico tipo `https://xxx.trycloudflare.com`.

## Test

### Health check

```bash
curl https://<tuo-url>.trycloudflare.com/health
```

Risposta attesa:
```json
{"status": "ok", "service": "adf-agent-webhook", "auth_enabled": true}
```

### Test webhook (payload finto)

```bash
curl -X POST https://<tuo-url>.trycloudflare.com/webhook/test \
  -H "Authorization: Bearer <TOKEN>"
```

### Test con payload Azure Monitor

```bash
curl -X POST https://<tuo-url>.trycloudflare.com/webhook/azure-alert \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{
    "schemaId": "azureMonitorCommonAlertSchema",
    "data": {
      "essentials": {
        "alertRule": "alert-sql-dtu-high",
        "severity": "Sev2",
        "monitorCondition": "Fired",
        "configurationItems": ["/subscriptions/.../databases/mydb"]
      }
    }
  }'
```

## Sicurezza

- **Autenticazione**: header `Authorization: Bearer <WEBHOOK_TOKEN>`.
  Se `WEBHOOK_TOKEN` non e' impostato, l'autenticazione e' **disabilitata** (solo per test locale).
- **Token**: NON committare il token nel repo. Usare variabili d'ambiente o Key Vault.
- **Produzione**: usare un named tunnel Cloudflare (URL stabile) + token robusto.

## Troubleshooting

| Problema | Causa | Soluzione |
|----------|-------|-----------|
| 401 Unauthorized | Token mancante/errato | Verifica `WEBHOOK_TOKEN` e header `Authorization` |
| 404 Not Found | URL Cloudflare errato | Verifica l'URL del tunnel |
| 502 Bad Gateway | Server locale non attivo | Avvia `run_webhook.ps1` |
| Timeout Azure | Diagnosi troppo lenta | Rispondere entro ~10s (async) |

## Prossime fasi

- **Fase 3**: tool `monitor.alert_to_agent` (parse payload + diagnosi)
- **Fase 4**: modulo Terraform `alert_to_agent` (crea alert + action group)
- **Fase 5**: test end-to-end con alert SQL DTU
