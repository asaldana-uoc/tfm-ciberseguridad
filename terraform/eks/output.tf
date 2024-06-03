output "endpoint" {
  description = "Endpoint del API Server del clúster EKS"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  description = "Nombre del clúster EKS"
  value       = aws_eks_cluster.this.name
}

output "openid_connect_provider_url" {
  description = "URL del proveedor OIDC"
  value       = aws_iam_openid_connect_provider.oidc_provider.url
}

output "openid_connect_provider_arn" {
  description = "Nombre del recurso de Amazon (ARN) del proveedor OIDC"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "openid_connect_provider_id" {
  description = "ID del proveedor OIDC"
  value       = aws_iam_openid_connect_provider.oidc_provider.id
}

output "cloudwatch_log_group" {
  description = "Nombre del grupo de CloudWatch donde se enviarán los logs"
  value       = aws_cloudwatch_log_group.cluster.name
}

