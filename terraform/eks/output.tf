output "endpoint" {
  description = "Endpoint del API Server"
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
