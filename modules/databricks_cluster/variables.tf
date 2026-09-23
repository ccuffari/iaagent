variable "cluster_name" {
  type = string
}

variable "spark_version" {
  type    = string
  default = "13.3.x-scala2.12"
}

variable "node_type_id" {
  type    = string
  default = "Standard_DS4_v2"
}

variable "num_workers" {
  type    = number
  default = 1
}

variable "autotermination_minutes" {
  type    = number
  default = 30
}

variable "data_security_mode" {
  type    = string
  default = "SINGLE_USER"
}

variable "tags" {
  type    = map(string)
  default = {}
}
