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
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Variable de tipo booleana para decidir si se crea un recurso NAT Gateway o no | `bool` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Variable de tipo booleana para elegir si AWS crea un registro DNS en el subdominio compute-1.amazonaws.com cuando se lanza una nueva instancia | `bool` | `null` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Variable de tipo booleana para decidir si las instancias del VPC pueden consultar el servidor DNS de Amazon | `bool` | `null` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Variable para definir la configuración de las subredes privadas del VPC. Es una variable de tipo map y los parámetros `cidr_block` y `name` son obligatorios. | `map(map(string))` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Variable para definir la configuración de las subredes públicas del VPC. Es una variable de tipo map y requiere que contenga las claves `cidr_block` y `name`. El parámetro `public_ip_on_launch` es opcional. | `map(map(string))` | n/a | yes |
| <a name="input_resources_name"></a> [resources\_name](#input\_resources\_name) | Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Direccionamiento IP para el VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_ip"></a> [nat\_gateway\_ip](#output\_nat\_gateway\_ip) | Dirección IP de la NAT Gateway |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | Identificadores de las subredes privadas creadas en el VPC |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Identificadores de las subredes públicas creadas en el VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Identificador del VPC creado |
<!-- END_TF_DOCS -->