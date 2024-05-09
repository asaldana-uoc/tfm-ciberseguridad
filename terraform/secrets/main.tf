resource "random_string" "secret" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "this" {
  name = coalesce(var.secret_name, format("%s-%s", var.resources_name, "secret"))
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = coalesce(var.secret_value, random_string.secret.result)
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account}"]
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

# Role
resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = format("%s-%s", aws_secretsmanager_secret.this.name, "role")
}


# Policy
data "aws_iam_policy_document" "get_secret" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [aws_secretsmanager_secret.this.arn]
  }
}

resource "aws_iam_policy" "get_secret" {
  name        = format("%s-%s", aws_secretsmanager_secret.this.name, "iam-policy")
  description = "Política IAM para obtener el valor de secrets de AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.get_secret.json
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "secrets_csi" {
  policy_arn = aws_iam_policy.get_secret.arn
  role       = aws_iam_role.this.name
}
