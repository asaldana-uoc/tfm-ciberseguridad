## Definimos la versión de las librerías para AWS que necesita este módulo
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
  }
}

# Recurso para generar un string aleatorio de 16 carácteres
resource "random_string" "secret" {
  length  = 16
  special = false
}

# Recursos para crear un secret en AWS Secrets Manager
resource "aws_secretsmanager_secret" "this" {
  name                    = coalesce(var.secret_name, format("%s-%s", var.resources_name, "secret"))
  recovery_window_in_days = var.secret_recovery_window_in_days
}

# Se añade una nueva versión del valor del secret creado con anterioridad
resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = coalesce(var.secret_value, random_string.secret.result)
}

# Se establecen las políticas de acceso que podrá tomar el rol IAM que se asocie a la service account de EKS
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.openid_connect_provider_url, "https://", "")}:sub"
      # En este punto se asocia el rol IAM con la Service Account del namespace de EKS
      values = ["system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.openid_connect_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.openid_connect_provider_arn]
      type        = "Federated"
    }
  }
}

# Se crea un rol IAM con las políticas de acceso anteriores
resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = format("%s-%s", aws_secretsmanager_secret.this.name, "role")
}


# Se definen las políticas para dar acceso al secret creado en AWS Secrets Manager
data "aws_iam_policy_document" "get_secret" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [aws_secretsmanager_secret.this.arn]
  }
}

# Se crear una política IAM con las directivas de acceso anteriores
resource "aws_iam_policy" "get_secret" {
  name        = format("%s-%s", aws_secretsmanager_secret.this.name, "iam-policy")
  description = "Política IAM para obtener el valor de secrets de AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.get_secret.json
}

# Se asocia la política IAM anterior que permite acceder al secret de AWS Secrets Manager al rol IAM
resource "aws_iam_role_policy_attachment" "secrets_csi" {
  policy_arn = aws_iam_policy.get_secret.arn
  role       = aws_iam_role.this.name
}
