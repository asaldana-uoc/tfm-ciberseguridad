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

resource "aws_cloudwatch_log_group" "cluster" {

  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = var.cloudwatch_log_retention_in_days
  log_group_class   = var.cloudwatch_log_group_class

  tags = { Name = "/aws/eks/${local.cluster_name}/cluster" }
}


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

# Policies attached ref https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Documentación https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
resource "aws_eks_cluster" "this" {
  name                      = local.cluster_name
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.cluster_version
  enabled_cluster_log_types = var.cluster_enabled_log_types

  vpc_config {
    subnet_ids              = var.cluster_subnets_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_allowed_cidrs
    security_group_ids      = var.cluster_security_group_ids
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster_encryption.arn
    }
    resources = ["secrets"]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_internal_ipv4_cidr
    ip_family         = "ipv4"
  }

  tags = {
    Name = local.cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_cloudwatch_log_group.cluster,
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "vpc-cni"
  addon_version = var.cluster_vpc_cni_addon_version

  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
  })
}

resource "aws_kms_key" "cluster_encryption" {
  description         = "Clave KMS para el cifrado de los secrets del cluster EKS"
  policy              = data.aws_iam_policy_document.kms_key_policy.json
  enable_key_rotation = true
}

resource "aws_kms_alias" "cluster_encryption" {
  name          = "alias/eks/${local.cluster_name}"
  target_key_id = aws_kms_key.cluster_encryption.id
}

data "aws_caller_identity" "current" {}

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

resource "aws_iam_policy" "cluster_encryption" {
  name        = format("%s-%s", local.cluster_name, "encryption-iam-policy")
  description = "Política IAM para el cifrado de los secrets de EKS"
  policy      = data.aws_iam_policy_document.cluster_encryption.json
}

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