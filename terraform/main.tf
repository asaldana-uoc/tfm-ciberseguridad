provider "aws" {
  region = "eu-south-2"
}

locals {
  region         = "eu-south-2"
  resources_name = "tfm-asaldana"
}

module "vpc" {
  source         = "./vpc"
  resources_name = local.resources_name

  vpc_cidr             = "172.16.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true
  create_nat_gateway   = true

  public_subnets = {
    az1 = {
      name       = "eu-south-2a",
      cidr_block = "172.16.0.0/23",
    }
    az2 = {
      name       = "eu-south-2b",
      cidr_block = "172.16.4.0/23",
    }
    az3 = {
      name       = "eu-south-2c",
      cidr_block = "172.16.8.0/23",
    }
  }

  private_subnets = {
    az1 = {
      name       = "eu-south-2a"
      cidr_block = "172.16.2.0/23",
    }
    az2 = {
      name       = "eu-south-2b",
      cidr_block = "172.16.6.0/23",
    }
    az3 = {
      name       = "eu-south-2c",
      cidr_block = "172.16.10.0/23",
    }
  }
}

data "http" "my_ip" {
  url = "https://curlmyip.net"
}

module "eks" {
  source         = "./eks"
  resources_name = local.resources_name

  cluster_enabled_log_types             = ["api", "audit", "authenticator", ]
  cluster_version                       = "1.29"
  cluster_subnets_ids                   = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = true
  cluster_endpoint_public_allowed_cidrs = formatlist("%s/32", [chomp(data.http.my_ip.response_body)])

  # https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
  cluster_vpc_cni_addon_version = "v1.18.0-eksbuild.1"

  # https://docs.aws.amazon.com/eks/latest/userguide/retrieve-ami-id-bottlerocket.html
  workers_ami_type       = "BOTTLEROCKET_x86_64"
  workers_subnets_ids    = module.vpc.private_subnet_ids
  workers_instances_type = ["m7i.large", "t3.large"]
  workers_disk_size      = 20
  workers_capacity_type  = "SPOT"
  workers_desired_size   = 1
  workers_min_size       = 1
  workers_max_size       = 3
}

terraform {
  required_version = ">= 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}