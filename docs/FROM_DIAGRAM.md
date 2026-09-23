# Tool `iac.from_diagram` — Da diagramma draw.io a Terraform deployato

Questo tool trasforma un diagramma **draw.io** in codice **Terraform** e lo deploya
via pipeline CI/CD.

## Panoramica

```
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  .drawio file    │───▶│ iac.from_diagram │───▶│  Terraform HCL   │
│  (nodi, frecce)  │    │  (parse+generate)│    │  (moduli + env)  │
└──────────────────┘    └──────────────────┘    └──────────────────┘
                                                          │
                                                          ▼
                                                ┌──────────────────┐
                                                │  CI/CD pipeline  │
                                                │  plan → apply    │
                                                └──────────────────┘
```

## Prerequisiti

1. **Diagramma draw.io** disegnato secondo `docs/DRAWIO_GUIDE.md`.
2. **Mapping icone** in `config/drawio_mapping.yaml` (gia' fornito).
3. **Moduli Terraform** in `modules/` (creati con `iac.scaffold_module`).
4. **Pipeline CI/CD** configurata (`.github/workflows/terraform-*.yml`).

## Azioni disponibili

| Azione | Scopo |
|--------|-------|
| `docs` | Restituisce i riferimenti alla guida e al mapping |
| `parse` | Analizza il .drawio e restituisce nodi/container/connessioni |
| `generate` | Genera l'HCL (dry-run, nessun commit) |
| `deploy` | Genera + committa + triggera la pipeline |

## Workflow consigliato

### 1. Verifica il diagramma (parse)

```json
{
  "action": "parse",
  "params": {
    "drawio_path": "docs/diagrams/infra.drawio"
  }
}
```

**Risposta:** nodi, container, connessioni, validazione.

### 2. Genera l'HCL (dry-run)

```json
{
  "action": "generate",
  "params": {
    "drawio_path": "docs/diagrams/infra.drawio",
    "environment": "dev",
    "dry_run": true
  }
}
```

**Risposta:** HCL generato + validazione. **Rivedi l'HCL prima di procedere.**

### 3. Deploy (commit + pipeline)

```json
{
  "action": "deploy",
  "params": {
    "drawio_path": "docs/diagrams/infra.drawio",
    "environment": "dev",
    "branch": "feature/from-diagram",
    "auto_deploy": false
  }
}
```

**Flusso:**
1. Genera HCL
2. Crea feature branch
3. Committa i file
4. Triggera pipeline `plan`
5. (Opzionale) Triggera pipeline `apply`

## Esempio completo

### Diagramma di input

```
┌─────────────────────────────────────────┐
│ RG: rg-ai-dev-we-01                      │
│                                          │
│  [SQL Server]──▶[SQL DB]                 │
│   sql-ai-dev    sql-db-ai-dev            │
│       │                                   │
│       │ (DIAG)                            │
│       ▼                                   │
│  [Log Analytics]                          │
│   log-ai-dev                              │
└─────────────────────────────────────────┘
```

### HCL generato

```hcl
module "sql_ai_dev_we_01" {
  source = "../../modules/sql_server"
  name   = "sql-ai-dev-we-01"
}

module "sql_db_ai_dev_we_01" {
  source = "../../modules/sql_database"
  name   = "sql-db-ai-dev-we-01"
}

module "log_ai_dev_we_01" {
  source = "../../modules/log_analytics"
  name   = "log-ai-dev-we-01"
}
```

## Validazione

Il tool verifica:

1. **Nomi validi** (naming convention Azure)
2. **Icone riconosciute** (mapping noto)
3. **Container coerenti** (nodi dentro RG/VNet)
4. **Connessioni valide** (tipi noti)
5. **Nessun segreto** in chiaro
6. **Nessuna risorsa duplicata**

Se la validazione fallisce, il tool **non genera** e segnala gli errori.

## Sicurezza

- **Segreti**: mai nel diagramma. Usa `#secret` + Key Vault references.
- **Review umana**: sempre prima dell'apply.
- **Guardia destroy**: se il piano distrugge risorse, l'apply e' bloccato.
- **Feature branch**: il deploy parte sempre da un branch, mai da `main`.

## Limitazioni

- **Non** gestisce risorse non mappate (segnala errore).
- **Non** inventa proprieta' non specificate (usa default).
- **Non** gestisce segreti (usa Key Vault references).
- **Non** gestisce logica condizionale complessa.
- **Non** sostituisce la review umana prima dell'apply.

## Riferimenti

- Guida disegno: `docs/DRAWIO_GUIDE.md`
- Mapping icone: `config/drawio_mapping.yaml`
- Naming: `config/naming.yaml`
- Esempio: `docs/infrastructure.drawio`
