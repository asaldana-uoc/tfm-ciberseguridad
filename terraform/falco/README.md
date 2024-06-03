<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#input\_cloudwatch\_log\_group) | Nombre del grupo de CloudWatch donde se encuentran los logs de EKS | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Nombre del namespace donde crear la Service Account | `string` | n/a | yes |
| <a name="input_kubernetes_service_account"></a> [kubernetes\_service\_account](#input\_kubernetes\_service\_account) | Nombre de la Service Account dentro del namespace anterior | `string` | n/a | yes |
| <a name="input_openid_connect_provider_id"></a> [openid\_connect\_provider\_id](#input\_openid\_connect\_provider\_id) | ID del proveedor OIDC del clúster EKS | `string` | n/a | yes |
| <a name="input_openid_connect_provider_url"></a> [openid\_connect\_provider\_url](#input\_openid\_connect\_provider\_url) | URL del proveedor OIDC del clúster EKS | `string` | n/a | yes |
| <a name="input_resources_name"></a> [resources\_name](#input\_resources\_name) | Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | Nombre del recurso de Amazon (ARN) del IAM role creado para la Service Account de EKS para Falcon |
<!-- END_TF_DOCS -->