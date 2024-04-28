variable "resources_name" {
  description = "Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente"
  type        = string
}

variable "cluster_version" {
  description = "Versión del clúster EKS. Más información en el enlace https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html"
  type        = string
}

variable "cluster_enabled_log_types" {
  description = "Lista de eventos del control plane a registrar en CloudWatch. Las opciones disponibles se pueden consultar en el enlace: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
  type        = list(string)
}

variable "cluster_subnets_ids" {
  description = "Identificador de las subredes del VPC donde desplegará el clúster EKS"
  type        = list(string)
}

variable "cluster_endpoint_private_access" {
  description = "Variable de tipo boolean para definir si el acceso a través de direccionamiento privado al API Server de EKS está permitido"
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Variable de tipo boolean para definir si el acceso a través de direccionamiento públic al API Server de EKS está permitido"
  type        = bool
}

variable "cluster_endpoint_public_allowed_cidrs" {
  description = "Lista de direcciones públicas permitidas a acceder al API Server de EKS si la variable `cluster_endpoint_public_access` es `true`"
  type        = list(string)
  default = null
}

variable "cluster_security_group_ids" {
  description = "Lista de identificadores de security group para las ENI que EKS crea para la comunicación entre workers y control plane"
  type        = list(string)
  default     = []
}

variable "cloudwatch_log_retention_in_days" {
  description = "Número de días de retención en CloudWatch de los logs generados por EKS"
  type        = number
  default     = 30
}

variable "cloudwatch_log_group_class" {
  description = "Tipo de grupo de logs de CloudWatch. Los valores admitidos son `STANDARD` or `INFREQUENT_ACCESS`. https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatch_Logs_Log_Classes.html"
  type        = string
  default     = null
}

variable "workers_attachment_policies" {
  type    = list(string)
  default = ["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly", "AmazonSSMManagedInstanceCore"]
}

variable "workers_subnets_ids" {
  description = "Identificador de las subredes del VPC donde desplegarán los worker nodes de EKS"
  type        = list(string)
}

variable "workers_ami_type" {
  description = "Tipo de imagen base (sistema operativo) para crear los worker nodes"
  type        = string
}

variable "workers_disk_size" {
  description = "Tamaño del disco duro (EBS) de los worker nodes"
  default     = 10
  type        = number
}

variable "workers_capacity_type" {
  description = "Tipo de instancias según la disponibilidades que necesitemos. Valores admitidos son `ON_DEMAND` o `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "workers_instances_type" {
  description = "Tipo de instancias (recursos de computación y memoria) para los workers nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "workers_desired_size" {
  description = "Número deseado de workers nodes en ejecución"
  type        = number
  default     = 1
}

variable "workers_max_size" {
  description = "Número máximo de workers nodes en ejecución"
  type        = number
  default     = 3
}

variable "workers_min_size" {
  description = "Número mínimo de workers nodes en ejecución"
  type        = number
  default     = 0
}

variable "workers_update_config_max_unavailable" {
  description = "Número máximo de workers nodes no disponibles durante el proceso de actualización de estos"
  type        = number
  default     = 1
}

variable "workers_remote_access_ssh_key" {
  description = "Keypair para acceder a través de SSH a los worker nodes"
  type        = string
  default     = null
}

variable "workers_source_security_group_ids" {
  description = "Lista de security groups a los que se les permitirá el acceso por SSH a los workers nodes haciendo uso de la clave anterior"
  type        = list(string)
  default     = []
}