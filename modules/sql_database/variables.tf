variable "name" {
  type = string
}

variable "server_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "GP_S_Gen5_1"
}

variable "tags" {
  description = "Tag da applicare al database SQL."
  type        = map(string)
  default     = {}
}
