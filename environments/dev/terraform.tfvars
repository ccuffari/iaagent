location = "westeurope"

# Fase 5 - webhook dell'agente (Cloudflare Tunnel)
# URL del tunnel che espone l'agente locale.
agent_webhook_url = "https://conscious-moms-dating-prep.trycloudflare.com/webhook/azure-alert"

# Destinatari email degli alert (action group)
alert_email_receivers = [
  { name = "admin", email = "cuffaricristianfelice@gmail.com" },
]
