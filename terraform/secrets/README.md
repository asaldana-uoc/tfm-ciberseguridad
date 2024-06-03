<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.get_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.secrets_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_string.secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.get_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Nombre del namespace donde crear la Service Account | `string` | n/a | yes |
| <a name="input_kubernetes_service_account"></a> [kubernetes\_service\_account](#input\_kubernetes\_service\_account) | Nombre de la Service Account dentro del namespace anterior | `string` | n/a | yes |
| <a name="input_openid_connect_provider_arn"></a> [openid\_connect\_provider\_arn](#input\_openid\_connect\_provider\_arn) | Nombre del recurso de Amazon (ARN) del proveedor OIDC del clúster EKS | `string` | n/a | yes |
| <a name="input_openid_connect_provider_url"></a> [openid\_connect\_provider\_url](#input\_openid\_connect\_provider\_url) | URL del proveedor OIDC del clúster EKS | `string` | n/a | yes |
| <a name="input_resources_name"></a> [resources\_name](#input\_resources\_name) | Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Nombre del secret a crear en AWS Secrets Manager | `string` | `null` | no |
| <a name="input_secret_recovery_window_in_days"></a> [secret\_recovery\_window\_in\_days](#input\_secret\_recovery\_window\_in\_days) | Tiempo a preservar el secret creado después de ser eliminado. Si el valor es 0, se borra directament. | `number` | `0` | no |
| <a name="input_secret_value"></a> [secret\_value](#input\_secret\_value) | Valor del secret a crear en AWS Secrets Manager | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | Nombre del recurso de Amazon (ARN) del IAM role creado para la Service Account de EKS para Secrets Manager |
<!-- END_TF_DOCS -->