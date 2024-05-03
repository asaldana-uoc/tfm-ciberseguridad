variable "repository_name" {
  description = "Nombre del repositorio ECR"
  type        = string
}

variable "image_tag_mutability" {
  description = "Parámetro para permitir sobreescribir un mismo tag con una nueva versión. Valores permitidos `MUTABLE` o `IMMUTABLE`"
  type        = string
  default     = "MUTABLE"
}


variable "image_scanning_on_push" {
  description = "Parámetro para activar o no la ejecución básica de escaneo de la imagen"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Forzar la eliminación del repositorio incluso si tiene imagenes"
  type        = bool
  default     = true
}