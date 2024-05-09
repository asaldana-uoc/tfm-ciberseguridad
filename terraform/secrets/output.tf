output "iam_role_arn" {
  description = "Nombre del recurso de Amazon (ARN) del IAM role creado para la Service Account de EKS"
  value       = aws_iam_role.this.arn
}
