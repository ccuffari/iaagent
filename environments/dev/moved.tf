# Blocchi 'moved' per il refactor degli indirizzi dei diagnostic settings.
# Il refactor ha spostato i diagnostic settings da risorse "piatte" a moduli.
# Senza questi blocchi, Terraform distrugge il vecchio indirizzo (destroy che si
# blocca su blobServices/default) e ricrea il nuovo (conflitto "already exists").
# Con 'moved', Terraform rinomina nello state senza distruggere/ricreare.
#
# Nota: un blocco 'moved' con 'from' non presente nello state viene ignorato
# silenziosamente, quindi e' sicuro elencarli tutti.

moved {
  from = azurerm_monitor_diagnostic_setting.storage_account
  to   = module.diag_storage_account.azurerm_monitor_diagnostic_setting.this
}

moved {
  from = azurerm_monitor_diagnostic_setting.storage_blob
  to   = module.diag_storage_blob.azurerm_monitor_diagnostic_setting.this
}

moved {
  from = azurerm_monitor_diagnostic_setting.adf
  to   = module.diag_adf.azurerm_monitor_diagnostic_setting.this
}

moved {
  from = azurerm_monitor_diagnostic_setting.key_vault
  to   = module.diag_key_vault.azurerm_monitor_diagnostic_setting.this
}

moved {
  from = azurerm_monitor_diagnostic_setting.sql_server
  to   = module.diag_sql_server.azurerm_monitor_diagnostic_setting.this
}

moved {
  from = azurerm_monitor_diagnostic_setting.sql_database
  to   = module.diag_sql_database.azurerm_monitor_diagnostic_setting.this
}
