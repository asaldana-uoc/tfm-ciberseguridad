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

variable "secret_recovery_window_in_days" {
  description = "Tiempo a preservar el secret creado después de ser eliminado. Si el valor es 0, se borra directament."
  type        = number
  default     = 0
}

variable "kubernetes_namespace" {
  description = "Nombre del namespace donde crear la Service Account"
  type        = string
}

variable "kubernetes_service_account" {
  description = "Nombre de la Service Account dentro del namespace anterior"
  type        = string
}

variable "openid_connect_provider_url" {
  description = "URL del proveedor OIDC del clúster EKS"
  type        = string
}

variable "openid_connect_provider_arn" {
  description = "Nombre del recurso de Amazon (ARN) del proveedor OIDC del clúster EKS"
  type        = string
}