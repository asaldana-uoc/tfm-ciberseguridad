<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [null_resource.docker_push](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Forzar la eliminación del repositorio incluso si tiene imagenes | `bool` | `true` | no |
| <a name="input_image_scanning_on_push"></a> [image\_scanning\_on\_push](#input\_image\_scanning\_on\_push) | Parámetro para activar o no la ejecución básica de escaneo de la imagen | `bool` | `true` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Parámetro para permitir sobreescribir un mismo tag con una nueva versión. Valores permitidos `MUTABLE` o `IMMUTABLE` | `string` | `"MUTABLE"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Nombre del repositorio ECR | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | URL del repositorio ECR creado |
<!-- END_TF_DOCS -->