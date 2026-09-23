# Guida: disegnare un diagramma draw.io per generare Terraform

Questa guida definisce le **regole di disegno** che il tool `iac.from_diagram` usa per
interpretare un file `.drawio` e generare il codice Terraform corrispondente.

> **Regola d'oro:** il diagramma e' una *specifica infrastrutturale*. Se e' ambiguo,
il Terraform generato sara' sbagliato. Segui le regole alla lettera.

---

## 1. Nodi (risorse)

Ogni **nodo** rappresenta una **risorsa Azure**.

### 1.1 Forma e icona

- Usa le **icone native draw.io** (`mxgraph.azure.*`).
- L'icona determina il **tipo di risorsa Terraform** (vedi `config/drawio_mapping.yaml`).

| Icona draw.io | Risorsa Terraform |
|---------------|-------------------|
| `mxgraph.azure.sql` | `azurerm_sql_server` |
| `mxgraph.azure.sql_database` | `azurerm_sql_database` |
| `mxgraph.azure.storage` | `azurerm_storage_account` |
| `mxgraph.azure.data_factory` | `azurerm_data_factory` |
| `mxgraph.azure.key_vault` | `azurerm_key_vault` |
| `mxgraph.azure.log_analytics` | `azurerm_log_analytics_workspace` |
| `mxgraph.azure.virtual_network` | `azurerm_virtual_network` |
| `mxgraph.azure.subnet` | `azurerm_subnet` |
| `mxgraph.azure.databricks` | `azurerm_databricks_workspace` |
| `mxgraph.azure.function` | `azurerm_function_app` |
| `mxgraph.azure.app_service` | `azurerm_app_service` |
| `mxgraph.azure.monitor` | `azurerm_monitor_*` |

### 1.2 Label del nodo

La label del nodo contiene **nome** e **proprieta'** (una per riga, formato `key=value`).

```
sql-ai-dev-we-01
sku=S0
region=westeurope
```

- **Prima riga** = nome della risorsa (obbligatorio).
- **Righe successive** = proprieta' opzionali (`key=value`).

### 1.3 Proprieta' riconosciute

| Proprieta' | Descrizione | Default |
|------------|-------------|---------|
| `sku` | SKU/tier della risorsa | dipende dal tipo |
| `region` | Regione Azure | `westeurope` |
| `tier` | Tier (es. Standard, Premium) | dipende dal tipo |
| `replication` | Replica storage (LRS, GRS) | `LRS` |
| `public` | Accesso pubblico (true/false) | `false` |
| `version` | Versione (es. runtime) | dipende dal tipo |

---

## 2. Container (RG, Subscription, VNet, Subnet)

I **container** raggruppano i nodi e ne determinano l'appartenenza.

### 2.1 Resource Group

- **Forma:** rettangolo con bordo **tratteggiato**.
- **Label:** `RG: <nome>`

```
RG: rg-ai-dev-we-01
```

Tutti i nodi **dentro** il rettangolo appartengono a quel RG.

### 2.2 Subscription

- **Forma:** rettangolo esterno (contiene i RG).
- **Label:** `SUB: <id>`

```
SUB: f4a32007-b8c2-4aee-9dc0-1421a27e36ad
```

### 2.3 Virtual Network

- **Forma:** rettangolo con label `VNET: <nome>`.
- **Proprieta':** `address_space=10.0.0.0/16`

```
VNET: vnet-ai-dev-we-01
address_space=10.0.0.0/16
```

### 2.4 Subnet

- **Forma:** rettangolo **dentro** una VNet.
- **Label:** `SUBNET: <nome>`
- **Proprieta':** `prefix=10.0.1.0/24`

```
SUBNET: snet-default
prefix=10.0.1.0/24
```

---

## 3. Connessioni (frecce)

Le **frecce** rappresentano **relazioni** tra risorse.

### 3.1 Tipi di freccia

| Label freccia | Significato | Terraform |
|---------------|-------------|-----------|
| *(nessuna)* | Dipendenza generica | `depends_on` |
| `PE` | Private Endpoint | `azurerm_private_endpoint` |
| `SE` | Service Endpoint | `service_endpoints` nella subnet |
| `DIAG` | Diagnostic Settings | `azurerm_monitor_diagnostic_setting` |
| `DATA` | Flusso dati (ADF) | dataset/linked service |
| `RBAC` | Role assignment | `azurerm_role_assignment` |

### 3.2 Esempi

```
[sql-server] --(DIAG)--> [log-analytics]
[sql-server] --(PE)--> [private-endpoint]
[adf] --(DATA)--> [storage]
```

---

## 4. Etichette speciali

Aggiungi queste etichette nella label del nodo per comportamenti speciali.

| Etichetta | Significato |
|-----------|-------------|
| `#skip` | Ignora il nodo (non genera Terraform) |
| `#manual` | Risorsa esistente, non gestita da Terraform |
| `#import` | Importa nello state (non creare) |
| `#secret` | Valore da Key Vault (non in chiaro) |
| `#existing` | Risorsa gia' esistente (usa `data` source) |

**Esempio:**
```
kv-ai-dev-we-01
#existing
```

---

## 5. Naming convention

I nomi nel diagramma **devono** rispettare la naming convention Azure:

```
<abbr>-<workload>-<env>-<region>-<instance>
```

| Esempio | Valido |
|---------|--------|
| `sql-ai-dev-we-01` | ✅ |
| `saaidevwe01` (storage, senza trattini) | ✅ |
| `SQL_Server_1` | ❌ |
| `myresource` | ❌ |

Se il nome non rispetta la convention, il tool lo segnala e propone un nome corretto
(via `naming.build`).

---

## 6. Esempio completo

```
┌─────────────────────────────────────────────────────────┐
│ SUB: f4a32007-b8c2-4aee-9dc0-1421a27e36ad                │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ RG: rg-ai-dev-we-01                                  │ │
│ │                                                      │ │
│ │  ┌──────────────┐      ┌──────────────┐             │ │
│ │  │ sql-server   │─────▶│ sql-database │             │ │
│ │  │ sql-ai-dev   │      │ sql-db-ai-dev│             │ │
│ │  │ sku=S0       │      │ sku=S0       │             │ │
│ │  └──────┬───────┘      └──────────────┘             │ │
│ │         │ (DIAG)                                     │ │
│ │         ▼                                            │ │
│ │  ┌──────────────┐                                   │ │
│ │  │ log-analytics│                                   │ │
│ │  │ log-ai-dev   │                                   │ │
│ │  └──────────────┘                                   │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

**Genera:**
- `module "sql_server"` (nome: `sql-ai-dev-we-01`)
- `module "sql_database"` (nome: `sql-db-ai-dev-we-01`, dipende da sql_server)
- `module "log_analytics"` (nome: `log-ai-dev-we-01`)
- `module "diag_sql_server"` (target: sql_server, workspace: log_analytics)

---

## 7. Regole di validazione

Il tool verifica:

1. **Nomi validi** (naming convention)
2. **Icone riconosciute** (mapping noto)
3. **Container coerenti** (nodi dentro RG/VNet)
4. **Connessioni valide** (tipi noti)
5. **Nessun segreto** in chiaro
6. **Nessuna risorsa duplicata**

Se la validazione fallisce, il tool **non genera** e segnala gli errori.

---

## 8. Workflow consigliato

1. Disegna il diagramma seguendo questa guida.
2. Salva come `docs/diagrams/<nome>.drawio`.
3. Esegui `iac.from_diagram` con `action=parse` (verifica).
4. Esegui `iac.from_diagram` con `action=generate` (dry-run HCL).
5. Rivedi l'HCL generato.
6. Esegui `iac.from_diagram` con `action=deploy` (commit + pipeline).

---

## 9. Limitazioni

- **Non** gestisce risorse non mappate (segnala errore).
- **Non** inventa proprieta' non specificate (usa default).
- **Non** gestisce segreti (usa Key Vault references).
- **Non** gestisce logica condizionale complessa.
- **Non** sostituisce la review umana prima dell'apply.

---

## 10. Riferimenti

- Mapping icone: `config/drawio_mapping.yaml`
- Tool: `iac.from_diagram`
- Naming: `config/naming.yaml`
- Esempio: `docs/infrastructure.drawio`
