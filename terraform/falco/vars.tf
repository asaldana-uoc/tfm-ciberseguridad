variable "resources_name" {
  description = "Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente"
  type        = string
}

variable "openid_connect_provider_id" {
  description = "ID del proveedor OIDC del clúster EKS"
  type        = string
}

variable "openid_connect_provider_url" {
  description = "URL del proveedor OIDC del clúster EKS"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Nombre del namespace donde crear la Service Account"
  type        = string
}

variable "kubernetes_service_account" {
  description = "Nombre de la Service Account dentro del namespace anterior"
  type        = string
}

variable "cloudwatch_log_group" {
  description = "Nombre del grupo de CloudWatch donde se encuentran los logs de EKS"
  type        = string
}