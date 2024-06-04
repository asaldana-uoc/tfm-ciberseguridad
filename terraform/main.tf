provider "aws" {
  region = "eu-south-2"
}

locals {
  region         = "eu-south-2"
  resources_name = "tfm-asaldana"
}

# Creación de la topología de red utilizando el módulo vpc
module "vpc" {
  source         = "./vpc"
  resources_name = local.resources_name

  # Direccionamiento IP elegido para el VPC
  vpc_cidr             = "172.16.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true
  create_nat_gateway   = true

  # Distribución de las subredes públicas dentro del VPC
  public_subnets = {
    az1 = {
      name       = "eu-south-2a",
      cidr_block = "172.16.0.0/23",
    }
    az2 = {
      name       = "eu-south-2b",
      cidr_block = "172.16.4.0/23",
    }
    az3 = {
      name       = "eu-south-2c",
      cidr_block = "172.16.8.0/23",
    }
  }

  # Distribución de las subredes privadas dentro del VPC
  private_subnets = {
    az1 = {
      name       = "eu-south-2a"
      cidr_block = "172.16.2.0/23",
    }
    az2 = {
      name       = "eu-south-2b",
      cidr_block = "172.16.6.0/23",
    }
    az3 = {
      name       = "eu-south-2c",
      cidr_block = "172.16.10.0/23",
    }
  }
}

# Recurso para obtener la IP actual de la persona o sistema que ejecuta terraform para que pueda acceder al endpoint del API Server
data "http" "my_ip" {
  url = "https://curlmyip.net"
}

# Creación del clúster EKS y el managed-node group
module "eks" {
  source         = "./eks"
  resources_name = local.resources_name

  cluster_enabled_log_types = ["api", "audit", "authenticator"]
  # Versión del clúster EKS https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
  cluster_version = "1.29"
  # El control plane se desplegará en todas las subredes (privadas y públicas) y el endpoint será accesible internamente y públicamente
  cluster_subnets_ids             = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  # Restringimos el acceso al endpoint del API server a únicamente la dirección IP obtenidad con la llamada data.http.my_ip
  cluster_endpoint_public_allowed_cidrs = formatlist("%s/32", [chomp(data.http.my_ip.response_body)])

  # Versión del plugin VPC CNI a utilizar
  # Documentación https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
  cluster_vpc_cni_addon_version = "v1.18.0-eksbuild.1"

  # Versión del addon Amazon EBS CSI a instalar
  # Documentación https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html
  cluster_aws_ebs_csi_addon_version = "v1.29.1-eksbuild.1"

  # AMI BOTTLEROCKET para los worker node
  # https://docs.aws.amazon.com/eks/latest/userguide/retrieve-ami-id-bottlerocket.html
  workers_ami_type = "BOTTLEROCKET_x86_64"
  # Los worker nodes se desplegarán únicamente en las subredes privadas creadas con el módulo vpc anterior
  workers_subnets_ids = module.vpc.private_subnet_ids
  # Tipo de instancias permitidas para tener en el grupo de nodos de EKS
  workers_instances_type = ["m7i.large", "t3.large"]
  workers_disk_size      = 20
  # Instancia de tipo SPOT, más económica que las ON_DEMMAND pero que puede ser apagada por AWS
  workers_capacity_type = "SPOT"
  # Configuraremos el grupo para que haya al menos una instancia en ejecución
  workers_desired_size = 1
  workers_min_size     = 1
  workers_max_size     = 3

  depends_on = [module.vpc]
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

# Módulo para crear un repositorio ECR donde almacenar imágenes de contenedores en AWS
module "ecr" {
  source          = "./ecr"
  repository_name = "debug-tools"
  force_delete    = true

  depends_on = [module.eks]
}

output "debug_image_url" {
  value = module.ecr.repository_url
}

# Módulo para crear un secret en AWS Secret Manager y un rol IAM de AWS que permitirá a los pods de EKS acceder al secret almacenado
module "secrets" {
  source                      = "./secrets"
  resources_name              = local.resources_name
  openid_connect_provider_url = module.eks.openid_connect_provider_url
  openid_connect_provider_arn = module.eks.openid_connect_provider_arn
  kubernetes_namespace        = "test-secrets-ns"
  kubernetes_service_account  = "test-secrets-sa"

  depends_on = [module.eks]
}

output "secrets_iam_role_arn" {
  value = module.secrets.iam_role_arn
}

# Módulo para crear un IAM role para que Falco pueda consultar los logs de EKS en CloudWatch
module "falco" {
  source                      = "./falco"
  resources_name              = format("%s-%s", local.resources_name, "falco")
  openid_connect_provider_id  = module.eks.openid_connect_provider_id
  openid_connect_provider_url = module.eks.openid_connect_provider_url
  kubernetes_namespace        = "falco"
  kubernetes_service_account  = "falco"
  cloudwatch_log_group        = module.eks.cloudwatch_log_group

  depends_on = [module.eks]
}

output "falco_iam_role_arn" {
  value = module.falco.iam_role_arn
}

terraform {
  required_version = ">= 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}