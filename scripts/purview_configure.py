#!/usr/bin/env python3
"""
Configura Azure Purview: registra data source e crea/avvia le scan.

Usa le Purview REST API (control plane + scanning) con autenticazione
via Managed Identity del runner (azure/login) o token da az CLI.

Idempotente: se una data source/scan esiste gia', la salta.
"""
import os
import sys
import json
import time
import urllib.request
import urllib.error

PURVIEW_ACCOUNT = os.environ.get("PURVIEW_ACCOUNT", "pvw-ai-dev-we-01")
RESOURCE_GROUP = os.environ.get("PURVIEW_RESOURCE_GROUP", "rg-ai-dev-we-01")
SUBSCRIPTION_ID = os.environ["ARM_SUBSCRIPTION_ID"]

# Endpoint Purview (control plane + scanning)
PURVIEW_ENDPOINT = f"https://{PURVIEW_ACCOUNT}.purview.azure.com"
SCAN_ENDPOINT = f"https://{PURVIEW_ACCOUNT}.scan.purview.azure.com"

# Data source da registrare: nome -> (kind, endpoint, collection)
DATA_SOURCES = {
    "ds-storage-01": {
        "kind": "AzureStorage",
        "endpoint": f"https://saaidevwe01.blob.core.windows.net/",
        "collection": "root",
    },
    "ds-storage-02": {
        "kind": "AzureStorage",
        "endpoint": f"https://saaidevwe02.blob.core.windows.net/",
        "collection": "root",
    },
    "ds-adf": {
        "kind": "AzureDataFactory",
        "endpoint": f"/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP}/providers/Microsoft.DataFactory/factories/adf-ai-dev-we-01",
        "collection": "root",
    },
    "ds-sql": {
        "kind": "AzureSqlDatabase",
        "endpoint": f"sql-ai-dev-we-01.database.windows.net",
        "collection": "root",
    },
}


def get_token():
    """Ottiene un token per Purview via az CLI (gia' autenticato nel runner)."""
    import subprocess
    out = subprocess.check_output(
        ["az", "account", "get-access-token",
         "--resource", "https://purview.azure.net",
         "--query", "accessToken", "-o", "tsv"],
        text=True,
    )
    return out.strip()


def api(method, url, token, body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req) as resp:
            raw = resp.read().decode()
            return resp.status, (json.loads(raw) if raw else {})
    except urllib.error.HTTPError as e:
        raw = e.read().decode()
        try:
            parsed = json.loads(raw)
        except Exception:
            parsed = {"raw": raw}
        return e.code, parsed


def register_data_source(name, cfg, token):
    url = f"{PURVIEW_ENDPOINT}/scan/datasources/{name}?api-version=2022-07-01-preview"
    body = {
        "kind": cfg["kind"],
        "properties": {
            "endpoint": cfg["endpoint"],
            "collection": {"referenceName": cfg["collection"], "type": "CollectionReference"},
        },
    }
    status, resp = api("PUT", url, token, body)
    print(f"[datasource] {name}: HTTP {status}")
    if status >= 400:
        print(f"  -> {json.dumps(resp)[:400]}")
    return status < 400


def create_scan(ds_name, scan_name, token):
    url = f"{SCAN_ENDPOINT}/datasources/{ds_name}/scans/{scan_name}?api-version=2022-07-01-preview"
    body = {
        "kind": "AzureStorageMsi" if ds_name.startswith("ds-storage") else "AzureResourceGroupMsi",
        "properties": {
            "scanRulesetName": "AzureStorage" if ds_name.startswith("ds-storage") else "AzureDataFactory",
            "scanRulesetType": "System",
        },
    }
    status, resp = api("PUT", url, token, body)
    print(f"[scan] {ds_name}/{scan_name}: HTTP {status}")
    if status >= 400:
        print(f"  -> {json.dumps(resp)[:400]}")
    return status < 400


def run_scan(ds_name, scan_name, token):
    url = f"{SCAN_ENDPOINT}/datasources/{ds_name}/scans/{scan_name}/run?api-version=2022-07-01-preview"
    status, resp = api("POST", url, token, {})
    print(f"[run] {ds_name}/{scan_name}: HTTP {status}")
    return status < 400


def main():
    token = get_token()
    print(f"Purview: {PURVIEW_ACCOUNT} ({PURVIEW_ENDPOINT})")

    ok = True
    for name, cfg in DATA_SOURCES.items():
        if not register_data_source(name, cfg, token):
            ok = False

    # Crea e avvia una scan per ogni data source
    for name in DATA_SOURCES:
        scan_name = f"scan-{name}"
        if create_scan(name, scan_name, token):
            run_scan(name, scan_name, token)

    if not ok:
        print("ATTENZIONE: alcune data source non sono state registrate.")
        sys.exit(1)
    print("Configurazione Purview completata.")


if __name__ == "__main__":
    main()
