provider "aws" {
  region = "eu-south-2"
}

locals {
  region         = "eu-south-2"
  resources_name = "tfm-ciberseguridad"
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

terraform {
  required_version = ">= 1.8"

  backend "local" {
    path = "./terraform.tfstate"
  }
}