locals {
  cluster_name          = format("%s-%s", var.resources_name, "eks-cluster")
  cluster_iam_role_name = format("%s-%s", local.cluster_name, "iam-role")
  workers_name          = format("%s-%s", var.resources_name, "eks-workers")
  workers_iam_role_name = format("%s-%s", local.workers_name, "iam-role")
  workers_group_name    = format("%s-%s", local.workers_name, "group")
}