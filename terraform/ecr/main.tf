# Recurso para crear un repositorio ECR para almacenar imágenes de contenedores
resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.image_scanning_on_push
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = <<EOF
	    aws ecr get-login-password --region ${data.aws_region.current.name} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com
	    docker buildx build -t "${aws_ecr_repository.this.repository_url}:latest" --platform=linux/amd64 -f ${path.module}/Dockerfile .
	    docker push "${aws_ecr_repository.this.repository_url}:latest"
	    EOF
  }

  triggers = {
    "run_at" = timestamp()
  }

  depends_on = [
    aws_ecr_repository.this,
  ]
}
