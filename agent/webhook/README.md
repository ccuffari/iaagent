# ADF Agent Webhook

Endpoint HTTP che riceve alert da Azure Monitor e avvia la diagnosi dell'agente.

## Architettura

```
Azure Monitor -> Action Group -> webhook HTTPS -> Cloudflare Tunnel -> agente locale
```

## Endpoints

| Endpoint | Metodo | Scopo |
|---|---|---|
| `/health` | GET | Health check (per Cloudflare Tunnel) |
| `/webhook/azure-alert` | POST | Riceve alert Azure Monitor |
| `/webhook/test` | POST | Payload di test |
| `/docs` | GET | Swagger UI (auto-generato) |

## Setup

```bash
# Installa dipendenze
pip install -r requirements.txt

# Configura variabili d'ambiente
export WEBHOOK_TOKEN="<token-segreto>"
export WEBHOOK_PORT=8000
export AGENT_AUTO_DIAGNOSE=true

# Avvia il server
python server.py
# oppure
uvicorn server:app --host 0.0.0.0 --port 8000
```

## Test

```bash
# Health check
curl http://localhost:8000/health

# Test payload
curl -X POST http://localhost:8000/webhook/test \
  -H "Content-Type: application/json" \
  -d '{"data": {"essentials": {"alertRule": "test", "severity": "2"}}}'
```

## Sicurezza

- Autenticazione via Bearer token (`WEBHOOK_TOKEN`)
- Validazione schema payload
- Logging di ogni richiesta
- WRITE sempre con approvazione umana

## Integrazione con Cloudflare Tunnel

```bash
cloudflared tunnel --url http://localhost:8000
```

L'URL pubblico generato va configurato nell'Action Group di Azure Monitor.
