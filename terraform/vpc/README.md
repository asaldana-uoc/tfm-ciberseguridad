<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Variable de tipo booleana para decidir si se crea un recurso NAT Gateway o no | `bool` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Variable de tipo booleana para elegir si AWS crea un registro DNS en el subdominio compute-1.amazonaws.com cuando se lanza una nueva instancia | `bool` | `null` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Variable de tipo booleana para decidir si las instancias del VPC pueden consultar el servidor DNS de Amazon | `bool` | `null` | no |
| <a name="input_enable_vpc_flow_flogs"></a> [enable\_vpc\_flow\_flogs](#input\_enable\_vpc\_flow\_flogs) | Variable de tipo booleana para elegir si activar o no VPC Flow Logs | `bool` | `false` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Variable para definir la configuración de las subredes privadas del VPC. Es una variable de tipo map y los parámetros `cidr_block` y `name` son obligatorios. | `map(map(string))` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Variable para definir la configuración de las subredes públicas del VPC. Es una variable de tipo map y requiere que contenga las claves `cidr_block` y `name`. El parámetro `public_ip_on_launch` es opcional. | `map(map(string))` | n/a | yes |
| <a name="input_resources_name"></a> [resources\_name](#input\_resources\_name) | Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Direccionamiento IP para el VPC | `string` | n/a | yes |
| <a name="input_vpc_flow_logs_cloudwatch_retention_in_days"></a> [vpc\_flow\_logs\_cloudwatch\_retention\_in\_days](#input\_vpc\_flow\_logs\_cloudwatch\_retention\_in\_days) | Número de días de retención en CloudWatch de VPC Flow Logs | `number` | `7` | no |
| <a name="input_vpc_flow_logs_cloudwatch_skip_destroy"></a> [vpc\_flow\_logs\_cloudwatch\_skip\_destroy](#input\_vpc\_flow\_logs\_cloudwatch\_skip\_destroy) | Variable de tipo booleana para decidir si preservar los logs incluso si se se eliminar el recurso con terraform | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_ip"></a> [nat\_gateway\_ip](#output\_nat\_gateway\_ip) | Dirección IP de la NAT Gateway |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Identificadores de las subredes privadas creadas en el VPC |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Identificadores de las subredes públicas creadas en el VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Identificador del VPC creado |
<!-- END_TF_DOCS -->