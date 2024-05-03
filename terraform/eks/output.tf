output "eks_endpoint" {
  description = "Endpoint del API Server"
  value       = aws_eks_cluster.this.endpoint
}
