data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Se establecen las políticas de acceso que podrá tomar el rol IAM que se asocie a la service account de EKS
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${var.openid_connect_provider_url}:sub"
      values   = ["system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account}"]
    }

    principals {
      identifiers = [
        var.openid_connect_provider_id
      ]
      type = "Federated"
    }
  }
}

# Se definen las políticas para dar acceso a los logs de EKS presentes en CloudWatch
data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid = "ReadAccessToCloudWatchLogs"
    actions = [
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:Get*",
      "logs:List*"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group}:*"
    ]
  }
}

# Se crea el rol IAM asociando la política que permite la integración de los permisos de EKS con los de AWS IAM
resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = format("%s-%s", var.resources_name, "role")
}

# Se vinculan las políticas de acceso a CloudWatch al rol de IAM
resource "aws_iam_role_policy" "this" {
  name   = format("%s-%s", var.resources_name, "policy")
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.cloudwatch.json
}
