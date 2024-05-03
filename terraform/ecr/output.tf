output "repository_url" {
  description = "URL del repositorio ECR creado"
  value       = aws_ecr_repository.this.name
}
