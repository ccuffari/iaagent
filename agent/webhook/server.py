"""
Webhook server per ricevere alert da Azure Monitor.

Espone un endpoint HTTP che Azure Monitor (via Action Group) invoca
quando scatta un alert. Il payload viene processato e passato all'agente
per la diagnosi automatica.

Endpoint:
  GET  /health                 -> health check (per Cloudflare Tunnel)
  POST /webhook/azure-alert    -> riceve alert Azure Monitor
  POST /webhook/test           -> payload di test (senza autenticazione)

Sicurezza:
  - Autenticazione via Bearer token (env WEBHOOK_TOKEN)
  - Validazione schema payload
  - Logging di ogni richiesta
"""

import os
import json
import logging
from datetime import datetime, timezone
from typing import Optional

from fastapi import FastAPI, HTTPException, Header, BackgroundTasks
from pydantic import BaseModel, Field


logging.basicConfig(
    level=os.environ.get("LOG_LEVEL", "INFO"),
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("webhook")

WEBHOOK_TOKEN = os.environ.get("WEBHOOK_TOKEN", "")
AGENT_AUTO_DIAGNOSE = os.environ.get("AGENT_AUTO_DIAGNOSE", "true").lower() == "true"

app = FastAPI(
    title="ADF Agent Webhook",
    description="Riceve alert da Azure Monitor e avvia la diagnosi dell'agente",
    version="1.0.0",
)


class AlertPayload(BaseModel):
    schemaId: Optional[str] = None
    data: dict = Field(default_factory=dict)


class AlertContext(BaseModel):
    alert_name: Optional[str] = None
    severity: Optional[str] = None
    monitor_condition: Optional[str] = None
    resource_ids: list = Field(default_factory=list)
    fired_time: Optional[str] = None
    metric_name: Optional[str] = None
    threshold: Optional[float] = None
    actual_value: Optional[float] = None


def _extract_context(payload: dict) -> AlertContext:
    data = payload.get("data", {})
    essentials = data.get("essentials", {})
    alert_context = data.get("alertContext", {})
    metric_name = None
    threshold = None
    actual_value = None
    condition = alert_context.get("condition", {}) if isinstance(alert_context, dict) else {}
    all_of = condition.get("allOf", []) if isinstance(condition, dict) else []
    if all_of:
        first = all_of[0]
        metric_name = first.get("metricName")
        threshold = first.get("threshold")
        actual_value = first.get("metricValue")
    return AlertContext(
        alert_name=essentials.get("alertRule"),
        severity=essentials.get("severity"),
        monitor_condition=essentials.get("monitorCondition"),
        resource_ids=essentials.get("configurationItems", []) or [],
        fired_time=essentials.get("firedDateTime"),
        metric_name=metric_name,
        threshold=threshold,
        actual_value=actual_value,
    )


def _validate_token(authorization: Optional[str]) -> None:
    if not WEBHOOK_TOKEN:
        logger.warning("WEBHOOK_TOKEN non configurato: autenticazione disabilitata")
        return
    if not authorization or authorization != f"Bearer {WEBHOOK_TOKEN}":
        raise HTTPException(status_code=401, detail="Unauthorized: invalid token")


def _invoke_agent(context: AlertContext) -> dict:
    logger.info(f"Invio contesto all'agente: {context.model_dump()}")
    return {
        "status": "diagnosis_started",
        "context": context.model_dump(),
        "note": "integrazione con monitor.alert_to_agent da completare",
    }


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "service": "adf-agent-webhook",
        "version": "1.0.0",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "auth_enabled": bool(WEBHOOK_TOKEN),
    }


@app.post("/webhook/azure-alert")
async def azure_alert(
    payload: AlertPayload,
    background_tasks: BackgroundTasks,
    authorization: Optional[str] = Header(None),
):
    _validate_token(authorization)
    logger.info(f"Alert ricevuto: schemaId={payload.schemaId}")
    context = _extract_context(payload.model_dump())
    logger.info(f"Contesto estratto: {context.model_dump()}")
    if AGENT_AUTO_DIAGNOSE:
        background_tasks.add_task(_invoke_agent, context)
    return {
        "status": "received",
        "alert_name": context.alert_name,
        "severity": context.severity,
        "resource_count": len(context.resource_ids),
        "diagnosis_started": AGENT_AUTO_DIAGNOSE,
        "received_at": datetime.now(timezone.utc).isoformat(),
    }


@app.post("/webhook/test")
async def test_webhook(payload: dict):
    logger.info(f"Test payload ricevuto: {json.dumps(payload)[:500]}")
    context = _extract_context(payload)
    return {
        "status": "test_ok",
        "context": context.model_dump(),
        "received_at": datetime.now(timezone.utc).isoformat(),
    }


@app.get("/")
async def root():
    return {
        "service": "adf-agent-webhook",
        "endpoints": [
            "GET  /health",
            "POST /webhook/azure-alert",
            "POST /webhook/test",
        ],
        "docs": "/docs",
    }


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("WEBHOOK_PORT", "8000"))
    uvicorn.run(app, host="0.0.0.0", port=port)
