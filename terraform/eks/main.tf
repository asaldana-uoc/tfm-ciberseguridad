## Variables locales usadas para los nombres de los recursos a crear
locals {
  cluster_name                  = format("%s-%s", var.resources_name, "eks-cluster")
  cluster_iam_role_name         = format("%s-%s", local.cluster_name, "iam-role")
  workers_name                  = format("%s-%s", var.resources_name, "eks-workers")
  workers_iam_role_name         = format("%s-%s", local.workers_name, "iam-role")
  workers_group_name            = format("%s-%s", local.workers_name, "group")
  identity_provider_config_name = format("%s-%s", var.resources_name, "idp")
}

#### Recursos para el Control Plane ####
data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Grupo de logs a crear en CloudWatch para almacenar los registros generados por el clúster EKS
resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = var.cloudwatch_log_retention_in_days
  log_group_class   = var.cloudwatch_log_group_class

  tags = { Name = "/aws/eks/${local.cluster_name}/cluster" }
}


# Se creá el IAM Role que se asignará al clúster EKS para que pueda interactuar con todos los servicios necesarios (CloudWatch, KMS, etc...)
resource "aws_iam_role" "cluster" {
  name_prefix = local.cluster_iam_role_name
  description = "Rol IAM que se asignará al control plane para darles permisos sobre ciertos servicios de AWS"

  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role_policy.json
  force_detach_policies = true

  inline_policy {
    name = local.cluster_iam_role_name

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogGroup"]
          Effect   = "Deny"
          Resource = "*"
        },
      ]
    })
  }

  tags = {
    Name = local.cluster_iam_role_name
  }

}

# Se asigna la policy predeterminada IAM AmazonEKSClusterPolicy al rol IAM creado para EKS
# Documentación https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Recurso para crear EKS clúster
# Documentación https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
resource "aws_eks_cluster" "this" {
  name                      = local.cluster_name
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.cluster_version
  enabled_cluster_log_types = var.cluster_enabled_log_types

  # Configuración de red proporcionada por las variables de entradas definidas en el archivo vars.tf
  vpc_config {
    subnet_ids              = var.cluster_subnets_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_allowed_cidrs
    security_group_ids      = var.cluster_security_group_ids
  }

  # Sección para forzar el cifrado en reposo de los Secrets de Kubernetes utilizando una clave KMS
  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster_encryption.arn
    }
    resources = ["secrets"]
  }

  # Configuración interna de red de EKS
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_internal_ipv4_cidr
    ip_family         = "ipv4"
  }

  tags = {
    Name = local.cluster_name
  }

  # El cluster no se creará hasta que el rol de seguridad IAM y el grupo de logs de CloudWatch no estén disponibles
  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_cloudwatch_log_group.cluster,
  ]
}

# Recurso para instalar el plugin VPC CNI en el clúster EKS creado
# Documentación https://github.com/asaldana-uoc/tfm-ciberseguridad/tree/34cecf89bf9374f5e02f93d62ddbb03fd40af23b/terraform/vpc
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "vpc-cni"
  addon_version = var.cluster_vpc_cni_addon_version

  # Configuración específica del plugin VPC CNI para activar el uso de NetworkPolicies
  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
  })
}

# Creación de la clave CMS para cifrar los Secrets de EKS
resource "aws_kms_key" "cluster_encryption" {
  description         = "Clave KMS para el cifrado de los secrets del cluster EKS"
  policy              = data.aws_iam_policy_document.kms_key_policy.json
  enable_key_rotation = true
}

# Alias de la clave KMS creada anteriormente
resource "aws_kms_alias" "cluster_encryption" {
  name          = "alias/eks/${local.cluster_name}"
  target_key_id = aws_kms_key.cluster_encryption.id
}

# Recurso de tipo informativo (data) para obtener las propiedades de la cuenta/región de AWS
data "aws_caller_identity" "current" {}

# Se establecen las políticas de acceso al servicio KMS
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid = "KMSKeyAdmins"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:TagResource"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        data.aws_caller_identity.current.arn
      ]
    }
    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    resources = ["*"]
  }
}

# Se crea una policy IAM con los permisos definidos en el recurso aws_iam_policy_document.kms_key_policy anterior
resource "aws_iam_policy" "cluster_encryption" {
  name        = format("%s-%s", local.cluster_name, "encryption-iam-policy")
  description = "Política IAM para el cifrado de los secrets de EKS"
  policy      = data.aws_iam_policy_document.cluster_encryption.json
}

# Se establecen las políticas de acceso al servicio KMS por parte de EKS
data "aws_iam_policy_document" "cluster_encryption" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ListGrants",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.cluster_encryption.arn]
  }
}

# Damos permisos al rol asignado al clúster de EKS para utilizar la clave KMS
resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  policy_arn = aws_iam_policy.cluster_encryption.arn
  role       = aws_iam_role.cluster.name
}

#### Recursos para el Data Plane (worker nodes) ####
data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid     = "EKSWorkersAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Se creá el IAM Role que se asignará a los workers nodes interactuar con todos los servicios necesarios (EKS, EKS CNI, ECR, System Manager, etc...)
resource "aws_iam_role" "workers" {
  name_prefix = local.workers_iam_role_name
  description = "Rol IAM que se asignará a los workers nodes para darles permisos sobre ciertos servicios de AWS"

  assume_role_policy    = data.aws_iam_policy_document.workers_assume_role_policy.json
  force_detach_policies = true

  tags = {
    Name = local.workers_iam_role_name
  }
}

# Se asignan las policies predefinidas de AWS y declaradas en la variable workers_attachment_policies.
# Si la variable no se sobreescribe, los workers nodes tendrán los permisos definidos en las policies: AmazonEKSWorkerNodePolicy,  AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly y AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "workers" {
  count      = length(var.workers_attachment_policies)
  policy_arn = "arn:aws:iam::aws:policy/${element(var.workers_attachment_policies, count.index)}"
  role       = aws_iam_role.workers.name
}

# Se crear un managed node group utilizando los parámetros de entradas definidos en el archivo vars.tf
resource "aws_eks_node_group" "workers" {
  # Vinculamos el managed group node con el clúster EKS creado anteriormente
  cluster_name           = aws_eks_cluster.this.name
  node_group_name_prefix = local.workers_group_name
  node_role_arn          = aws_iam_role.workers.arn

  subnet_ids = var.workers_subnets_ids

  # Tipo de imagen e instancia utilizadas
  ami_type       = var.workers_ami_type
  capacity_type  = var.workers_capacity_type
  instance_types = var.workers_instances_type

  # Propiedades del auto escalado
  scaling_config {
    desired_size = var.workers_desired_size
    max_size     = var.workers_max_size
    min_size     = var.workers_min_size
  }

  update_config {
    max_unavailable = var.workers_update_config_max_unavailable
  }

  # El recurso no se creará hasta que el rol IAM que necesitan para funcionar no esté disponible
  depends_on = [
    aws_iam_role_policy_attachment.workers,
  ]

  # Medida de precaución para crear instancias nuevas antes de eliminar las existentes
  lifecycle {
    create_before_destroy = true
  }

  # Tiempo máximo permitido para finalizar las operaciones de creación, actualización y eliminación.
  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# Creamos el proveedor de identidades OIDC
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = {
    Name = local.cluster_name
  }
}

# Asociamos el proveedor OIDC al clúster EKS
resource "aws_eks_identity_provider_config" "this" {
  cluster_name = aws_eks_cluster.this.name
  oidc {
    client_id                     = substr(aws_eks_cluster.this.identity.0.oidc.0.issuer, -32, -1)
    identity_provider_config_name = local.identity_provider_config_name
    issuer_url                    = "https://${aws_iam_openid_connect_provider.oidc_provider.url}"
  }
}