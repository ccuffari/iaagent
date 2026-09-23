"""Server FastAPI per ricevere gli alert di Azure Monitor e avviare la diagnosi dell'agente.

Endpoint:
  GET  /health                 -> health check (per Cloudflare Tunnel)
  POST /webhook/azure-alert    -> riceve il payload di Azure Monitor
  POST /webhook/test           -> endpoint di test con payload finto

Sicurezza:
  - Autenticazione via header 'Authorization: Bearer <WEBHOOK_TOKEN>' (env var).
  - Se WEBHOOK_TOKEN non e' impostato, l'autenticazione e' disabilitata (solo per test locale).
"""

import os
import json
import logging
from datetime import datetime, timezone

from fastapi import FastAPI, Request, HTTPException, Header
from fastapi.responses import JSONResponse


try:
    from adf_agent.plugins.monitor__alert_to_agent import run as alert_to_agent_run
except Exception:  # pragma: no cover - fallback se il plugin non e' importabile
    alert_to_agent_run = None


logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("webhook")

app = FastAPI(title="ADF Agent Webhook", version="1.0.0")

WEBHOOK_TOKEN = os.environ.get("WEBHOOK_TOKEN", "")


def _check_auth(authorization: str | None):
    """Valida il token Bearer se configurato."""
    if not WEBHOOK_TOKEN:
        return True
    if not authorization:
        return False
    expected = f"Bearer {WEBHOOK_TOKEN}"
    return authorization == expected


def _extract_context(payload: dict) -> dict:
    """Estrae il contesto utile dal payload di Azure Monitor."""
    data = payload.get("data") or {}
    essentials = data.get("essentials") or {}
    alert_context = data.get("alertContext") or {}
    return {
        "alert_name": essentials.get("alertRule"),
        "severity": essentials.get("severity"),
        "monitor_condition": essentials.get("monitorCondition"),
        "fired_time": essentials.get("firedDateTime"),
        "resource_ids": essentials.get("configurationItems") or [],
        "alert_context": alert_context,
        "received_at": datetime.now(timezone.utc).isoformat(),
    }


def _invoke_agent(payload: dict) -> dict:
    """Invoca il tool monitor.alert_to_agent per la diagnosi."""
    if alert_to_agent_run is None:
        return {"ok": False, "error": "plugin monitor.alert_to_agent non disponibile"}
    try:
        return alert_to_agent_run(
            action="handle",
            params={"alert_payload": payload, "auto_diagnose": True, "auto_remediate": False},
        )
    except Exception as e:
        logger.exception("Errore nell'invocazione del tool monitor.alert_to_agent")
        return {"ok": False, "error": str(e)}


@app.get("/health")
async def health():
    """Health check per Cloudflare Tunnel e monitoraggio."""
    return {"status": "ok", "service": "adf-agent-webhook",
            "auth_enabled": bool(WEBHOOK_TOKEN),
            "agent_available": alert_to_agent_run is not None,
            "timestamp": datetime.now(timezone.utc).isoformat()}


@app.post("/webhook/azure-alert")
async def azure_alert(request: Request, authorization: str = Header(None)):
    """Riceve un alert di Azure Monitor e avvia la diagnosi."""
    if not _check_auth(authorization):
        logger.warning("Richiesta non autorizzata")
        raise HTTPException(status_code=401, detail="Unauthorized")

    try:
        payload = await request.json()
    except Exception as e:
        logger.error(f"Payload non valido: {e}")
        raise HTTPException(status_code=400, detail="Invalid JSON payload")

    context = _extract_context(payload)
    logger.info(f"Alert ricevuto: {json.dumps(context, default=str)}")

    # Invoca il tool monitor.alert_to_agent per la diagnosi.
    diagnosis = _invoke_agent(payload)
    logger.info(f"Diagnosi: {json.dumps(diagnosis, default=str)}")

    return JSONResponse(status_code=200, content={
        "status": "received",
        "context": context,
        "diagnosis": diagnosis,
    })


@app.post("/webhook/test")
async def webhook_test(authorization: str = Header(None)):
    """Endpoint di test con payload finto (per validare il giro Cloudflare -> agente)."""
    if not _check_auth(authorization):
        raise HTTPException(status_code=401, detail="Unauthorized")
    fake = {
        "schemaId": "azureMonitorCommonAlertSchema",
        "data": {
            "essentials": {
                "alertRule": "alert-sql-dtu-high (test)",
                "severity": "Sev2",
                "monitorCondition": "Fired",
                "firedDateTime": datetime.now(timezone.utc).isoformat(),
                "configurationItems": ["/subscriptions/test/resourceGroups/test/providers/Microsoft.Sql/servers/test/databases/test"],
            },
            "alertContext": {"condition": {"metricName": "dtu_consumption_percent", "threshold": 80}},
        },
    }
    context = _extract_context(fake)
    diagnosis = _invoke_agent(fake)
    logger.info(f"Test webhook: {json.dumps(context, default=str)}")
    return {"status": "ok", "context": context, "diagnosis": diagnosis}


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("WEBHOOK_PORT", "8000"))
    uvicorn.run(app, host="0.0.0.0", port=port)
