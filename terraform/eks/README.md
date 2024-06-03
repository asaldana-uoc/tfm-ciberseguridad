<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_identity_provider_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) | resource |
| [aws_eks_node_group.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cluster_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.workers_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_class"></a> [cloudwatch\_log\_group\_class](#input\_cloudwatch\_log\_group\_class) | Tipo de grupo de logs de CloudWatch. Los valores admitidos son `STANDARD` or `INFREQUENT_ACCESS`. https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatch_Logs_Log_Classes.html | `string` | `null` | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Número de días de retención en CloudWatch de los logs generados por EKS | `number` | `30` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | Lista de eventos del control plane a registrar en CloudWatch. Las opciones disponibles se pueden consultar en el enlace: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html | `list(string)` | n/a | yes |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Variable de tipo boolean para definir si el acceso a través de direccionamiento privado al API Server de EKS está permitido | `bool` | n/a | yes |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Variable de tipo boolean para definir si el acceso a través de direccionamiento públic al API Server de EKS está permitido | `bool` | n/a | yes |
| <a name="input_cluster_endpoint_public_allowed_cidrs"></a> [cluster\_endpoint\_public\_allowed\_cidrs](#input\_cluster\_endpoint\_public\_allowed\_cidrs) | Lista de direcciones públicas permitidas a acceder al API Server de EKS si la variable `cluster_endpoint_public_access` es `true` | `list(string)` | `null` | no |
| <a name="input_cluster_internal_ipv4_cidr"></a> [cluster\_internal\_ipv4\_cidr](#input\_cluster\_internal\_ipv4\_cidr) | Direccionamiento de red interno del clúster de Kubernetes | `string` | `null` | no |
| <a name="input_cluster_security_group_ids"></a> [cluster\_security\_group\_ids](#input\_cluster\_security\_group\_ids) | Lista de identificadores de security group para las ENI que EKS crea para la comunicación entre workers y control plane | `list(string)` | `[]` | no |
| <a name="input_cluster_subnets_ids"></a> [cluster\_subnets\_ids](#input\_cluster\_subnets\_ids) | Identificador de las subredes del VPC donde desplegará el clúster EKS | `list(string)` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Versión del clúster EKS. Más información en el enlace https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html | `string` | n/a | yes |
| <a name="input_cluster_vpc_cni_addon_version"></a> [cluster\_vpc\_cni\_addon\_version](#input\_cluster\_vpc\_cni\_addon\_version) | Version del addon VPC CNI para EKS | `string` | `null` | no |
| <a name="input_resources_name"></a> [resources\_name](#input\_resources\_name) | Prefijo que se añadirá al nombre de todos los recursos que se creen en este módulo para identificarlos fácilmente | `string` | n/a | yes |
| <a name="input_workers_ami_type"></a> [workers\_ami\_type](#input\_workers\_ami\_type) | Tipo de imagen base (sistema operativo) para crear los worker nodes | `string` | n/a | yes |
| <a name="input_workers_attachment_policies"></a> [workers\_attachment\_policies](#input\_workers\_attachment\_policies) | n/a | `list(string)` | <pre>[<br>  "AmazonEKSWorkerNodePolicy",<br>  "AmazonEKS_CNI_Policy",<br>  "AmazonEC2ContainerRegistryReadOnly",<br>  "AmazonSSMManagedInstanceCore"<br>]</pre> | no |
| <a name="input_workers_capacity_type"></a> [workers\_capacity\_type](#input\_workers\_capacity\_type) | Tipo de instancias según la disponibilidades que necesitemos. Valores admitidos son `ON_DEMAND` o `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_workers_desired_size"></a> [workers\_desired\_size](#input\_workers\_desired\_size) | Número deseado de workers nodes en ejecución | `number` | `1` | no |
| <a name="input_workers_disk_size"></a> [workers\_disk\_size](#input\_workers\_disk\_size) | Tamaño del disco duro (EBS) de los worker nodes | `number` | `10` | no |
| <a name="input_workers_instances_type"></a> [workers\_instances\_type](#input\_workers\_instances\_type) | Tipo de instancias (recursos de computación y memoria) para los workers nodes | `list(string)` | <pre>[<br>  "t3.micro"<br>]</pre> | no |
| <a name="input_workers_max_size"></a> [workers\_max\_size](#input\_workers\_max\_size) | Número máximo de workers nodes en ejecución | `number` | `3` | no |
| <a name="input_workers_min_size"></a> [workers\_min\_size](#input\_workers\_min\_size) | Número mínimo de workers nodes en ejecución | `number` | `0` | no |
| <a name="input_workers_remote_access_ssh_key"></a> [workers\_remote\_access\_ssh\_key](#input\_workers\_remote\_access\_ssh\_key) | Keypair para acceder a través de SSH a los worker nodes | `string` | `null` | no |
| <a name="input_workers_source_security_group_ids"></a> [workers\_source\_security\_group\_ids](#input\_workers\_source\_security\_group\_ids) | Lista de security groups a los que se les permitirá el acceso por SSH a los workers nodes haciendo uso de la clave anterior | `list(string)` | `[]` | no |
| <a name="input_workers_subnets_ids"></a> [workers\_subnets\_ids](#input\_workers\_subnets\_ids) | Identificador de las subredes del VPC donde desplegarán los worker nodes de EKS | `list(string)` | n/a | yes |
| <a name="input_workers_update_config_max_unavailable"></a> [workers\_update\_config\_max\_unavailable](#input\_workers\_update\_config\_max\_unavailable) | Número máximo de workers nodes no disponibles durante el proceso de actualización de estos | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#output\_cloudwatch\_log\_group) | Nombre del grupo de CloudWatch donde se enviarán los logs |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Nombre del clúster EKS |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint del API Server |
| <a name="output_openid_connect_provider_arn"></a> [openid\_connect\_provider\_arn](#output\_openid\_connect\_provider\_arn) | Nombre del recurso de Amazon (ARN) del proveedor OIDC |
| <a name="output_openid_connect_provider_id"></a> [openid\_connect\_provider\_id](#output\_openid\_connect\_provider\_id) | ID del proveedor OIDC |
| <a name="output_openid_connect_provider_url"></a> [openid\_connect\_provider\_url](#output\_openid\_connect\_provider\_url) | URL del proveedor OIDC |
<!-- END_TF_DOCS -->