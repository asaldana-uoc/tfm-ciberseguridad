variable "resources_name" {
  description = "Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente"
}

variable "vpc_cidr" {
  description = "Direccionamiento IP para el VPC"
  type        = string
}

variable "public_subnets" {
  description = "Variable para definir la configuración de las subredes públicas del VPC. Es una variable de tipo map y requiere que contenga las claves `cidr_block` y `name`. El parámetro `public_ip_on_launch` es opcional."
  type        = map(map(string))
}

variable "private_subnets" {
  description = "Variable para definir la configuración de las subredes privadas del VPC. Es una variable de tipo map y los parámetros `cidr_block` y `name` son obligatorios."
  type        = map(map(string))
}

variable "create_nat_gateway" {
  description = "Variable de tipo booleana para decidir si se crea un recurso NAT Gateway o no"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "Variable de tipo booleana para elegir si AWS crea un registro DNS en el subdominio compute-1.amazonaws.com cuando se lanza una nueva instancia"
  type        = bool
  default     = null
}

variable "enable_dns_support" {
  description = "Variable de tipo booleana para decidir si las instancias del VPC pueden consultar el servidor DNS de Amazon"
  type        = bool
  default     = null
}
