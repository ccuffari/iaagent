# Variabili dell'ambiente dev
# Solo le variabili effettivamente usate dai moduli.

variable "location" {
  description = "Regione Azure per le risorse"
  type        = string
  default     = "westeurope"
}
