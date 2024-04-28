data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid     = "EKSWorkersAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "workers" {
  name_prefix = local.workers_iam_role_name
  description = "Rol IAM que se asignará a los workers nodes para darles permisos sobre ciertos servicios de AWS"

  assume_role_policy    = data.aws_iam_policy_document.workers_assume_role_policy.json
  force_detach_policies = true

  tags = {
    Name = local.workers_iam_role_name
  }
}

resource "aws_iam_role_policy_attachment" "workers" {
  count      = length(var.workers_attachment_policies)
  policy_arn = "arn:aws:iam::aws:policy/${element(var.workers_attachment_policies, count.index)}"
  role       = aws_iam_role.workers.name
}

resource "aws_eks_node_group" "workers" {
  cluster_name           = aws_eks_cluster.this.name
  node_group_name_prefix = local.workers_group_name
  node_role_arn          = aws_iam_role.workers.arn

  subnet_ids = var.workers_subnets_ids

  ami_type       = var.workers_ami_type
  capacity_type  = var.workers_capacity_type
  instance_types = var.workers_instances_type

  scaling_config {
    desired_size = var.workers_desired_size
    max_size     = var.workers_max_size
    min_size     = var.workers_min_size
  }

  update_config {
    max_unavailable = var.workers_update_config_max_unavailable
  }

  depends_on = [
    aws_iam_role_policy_attachment.workers,
  ]

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}
