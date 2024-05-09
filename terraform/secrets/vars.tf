variable "resources_name" {
  description = "Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente"
  type        = string
}

variable "secret_name" {
  description = "Nombre del secret a crear en AWS Secrets Manager"
  type        = string
  default     = null
}

variable "secret_value" {
  description = "Valor del secret a crear en AWS Secrets Manager"
  type        = string
  default     = null
}

variable "kubernetes_namespace" {
  description = "Nombre del namespace donde crear Service Account"
  type        = string
}

variable "kubernetes_service_account" {
  description = "Nombre de la Service Account dentro del namespace anterior"
  type        = string
}

variable "openid_connect_provider_url" {
  type = string
}

variable "openid_connect_provider_arn" {
  type = string
}