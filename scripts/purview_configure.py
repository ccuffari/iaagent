#!/usr/bin/env python3
"""
Configura Azure Purview: registra data source e crea/avvia le scan.

Usa l'SDK ufficiale azure-purview-scanning.
Autenticazione via DefaultAzureCredential (azure/login nel runner).

Idempotente: se una data source/scan esiste gia', la aggiorna.
"""
import os
import sys

from azure.identity import DefaultAzureCredential
from azure.purview.scanning import PurviewScanningClient
from azure.core.exceptions import HttpResponseError

PURVIEW_ACCOUNT = os.environ.get("PURVIEW_ACCOUNT", "pvw-ai-dev-we-01")
RESOURCE_GROUP = os.environ.get("PURVIEW_RESOURCE_GROUP", "rg-ai-dev-we-01")
SUBSCRIPTION_ID = os.environ["ARM_SUBSCRIPTION_ID"]

ENDPOINT = f"https://{PURVIEW_ACCOUNT}.purview.azure.com"

# La root collection ha come referenceName il nome dell'account Purview.
ROOT_COLLECTION = PURVIEW_ACCOUNT

DATA_SOURCES = {
    "ds-storage-01": {
        "kind": "AzureStorage",
        "endpoint": "https://saaidevwe01.blob.core.windows.net/",
    },
    "ds-storage-02": {
        "kind": "AzureStorage",
        "endpoint": "https://saaidevwe02.blob.core.windows.net/",
    },
    "ds-adf": {
        "kind": "AzureDataFactory",
        "endpoint": f"/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP}/providers/Microsoft.DataFactory/factories/adf-ai-dev-we-01",
    },
    "ds-sql": {
        "kind": "AzureSqlDatabase",
        "endpoint": "sql-ai-dev-we-01.database.windows.net",
    },
}


def register_data_source(client, name, cfg):
    body = {
        "name": name,
        "kind": cfg["kind"],
        "properties": {
            "endpoint": cfg["endpoint"],
            "resourceGroup": RESOURCE_GROUP,
            "subscriptionId": SUBSCRIPTION_ID,
            "collection": {"referenceName": ROOT_COLLECTION, "type": "CollectionReference"},
        },
    }
    try:
        client.data_sources.create_or_update(data_source_name=name, body=body)
        print(f"[datasource] {name}: OK")
        return True
    except HttpResponseError as e:
        print(f"[datasource] {name}: ERRORE {e.status_code} - {e.message}")
        return False


def create_scan(client, ds_name, scan_name):
    if ds_name.startswith("ds-storage"):
        kind, ruleset = "AzureStorageMsi", "AzureStorage"
    elif ds_name.startswith("ds-adf"):
        kind, ruleset = "AzureResourceGroupMsi", "AzureDataFactory"
    else:
        kind, ruleset = "AzureSqlDatabaseMsi", "AzureSqlDatabase"
    body = {
        "name": scan_name,
        "kind": kind,
        "properties": {
            "scanRulesetName": ruleset,
            "scanRulesetType": "System",
        },
    }
    try:
        client.scans.create_or_update(data_source_name=ds_name, scan_name=scan_name, body=body)
        print(f"[scan] {ds_name}/{scan_name}: OK")
        return True
    except HttpResponseError as e:
        print(f"[scan] {ds_name}/{scan_name}: ERRORE {e.status_code} - {e.message}")
        return False


def run_scan(client, ds_name, scan_name):
    try:
        client.scans.run_scan(data_source_name=ds_name, scan_name=scan_name)
        print(f"[run] {ds_name}/{scan_name}: avviata")
        return True
    except HttpResponseError as e:
        print(f"[run] {ds_name}/{scan_name}: ERRORE {e.status_code} - {e.message}")
        return False


def main():
    cred = DefaultAzureCredential()
    client = PurviewScanningClient(endpoint=ENDPOINT, credential=cred)
    print(f"Purview: {PURVIEW_ACCOUNT} ({ENDPOINT})")

    ok = True
    for name, cfg in DATA_SOURCES.items():
        if not register_data_source(client, name, cfg):
            ok = False

    for name in DATA_SOURCES:
        scan_name = f"scan-{name}"
        if create_scan(client, name, scan_name):
            run_scan(client, name, scan_name)

    if not ok:
        print("ATTENZIONE: alcune data source non sono state registrate.")
        sys.exit(1)
    print("Configurazione Purview completata.")


if __name__ == "__main__":
    main()
