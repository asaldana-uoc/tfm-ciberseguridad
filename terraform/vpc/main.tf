## Definimos la versión de las librerías para AWS que necesita este módulo
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
  }
}

## Variables locales utilizadas en este módulo para definir el nombre del VPC con un formato específico
locals {
  vpc_name = format("%s-%s", var.resources_name, "vpc")
}

# Recurso para crear el VPC usando los parámetros del archivo vars.tf
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = local.vpc_name
  }
}

# Se crea el security group por defecto del VPC
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = format("%s-default-security-group", local.vpc_name)
  }
}

# Se crea la tabla de rutas por defecto del VPC
resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name = format("%s-default-route-table", local.vpc_name)
  }
}

# Se crea la recurso Internet Gateway del VPC que permite el acceso a Internet de las instancias que estén en las redes públicas
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = format("%s-internet-gateway", local.vpc_name)
  }
}

# Se reserva una IP estática (Elastic IP) para asignar a la NAT Gateway
resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  tags = {
    Name = format("%s-eip-nat-gateway", local.vpc_name)
  }
  depends_on = [aws_internet_gateway.this]
}

# Se crea la recurso NAT Gateway en una de las subredes públicas para dar acceso a Internet de las instancias que estén en las redes privdas
resource "aws_nat_gateway" "this" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = element([for subnet in aws_subnet.public : subnet.id], 0)

  tags = {
    Name = format("%s-nat-gateway", local.vpc_name)
  }

  depends_on = [aws_internet_gateway.this]
}

# Recurso para crear 1 a N redes públicas en función de los valores del objeto map public_subnets del archivo vars.tf
resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  cidr_block              = each.value.cidr_block
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.name
  map_public_ip_on_launch = try(each.value.public_ip_on_launch, false)

  tags = {
    Name = format("%s-public-%s", local.vpc_name, each.value.name)
    # Etiqueta importante para permitir la creación de Load Balancer públicos utilizando objetos de Kubernetes
    # Documentación https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
    "kubernetes.io/role/elb" = 1
    Type                     = "public"
  }
}

# Tabla de rutas para las redes públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = format("%s-public-route-table", local.vpc_name)
  }
}

# Asociación de la tabla de rutas con las redes públicas
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


# Recurso para crear 1 a N redes privadas en función de los valores del objeto map private_subnets del archivo vars.tf
resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.name

  tags = {
    Name = format("%s-private-%s", local.vpc_name, each.value.name)
    # Etiqueta importante para permitir la creación de Load Balancer privados utilizando objetos de Kubernetes
    Type                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# Tabla de rutas para las redes privadas
resource "aws_route_table" "private" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = format("%s-private-route-table", local.vpc_name)
  }
}

# Asociación de la tabla de rutas con las redes privadas
resource "aws_route_table_association" "private" {
  for_each       = { for k, v in var.private_subnets : k => v if var.create_nat_gateway }
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[0].id
}

# Recurso para crear VPC Flow Logs
resource "aws_flow_log" "this" {
  count           = var.enable_vpc_flow_flogs ? 1 : 0
  iam_role_arn    = aws_iam_role.this[0].arn
  log_destination = aws_cloudwatch_log_group.this[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

  tags = {
    Name = format("%s-private-route-table", local.vpc_name)
  }
}

# Grupo de CloudWatch para almacenar los registros de la actividad del tráfico de red dentro de la VPC
resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_vpc_flow_flogs ? 1 : 0
  name              = "/aws/vpc/${local.vpc_name}/vpc-flow-logs"
  retention_in_days = var.vpc_flow_logs_cloudwatch_retention_in_days
  skip_destroy      = var.vpc_flow_logs_cloudwatch_skip_destroy

  tags = {
    Name = format("%s-vpc-flow-logs", local.vpc_name)
  }
}

# Permisos otorgados al servicio VPC Flow Logs para poder acceder a los servicios VPC y CloudWatch
data "aws_iam_policy_document" "assume_role" {
  count = var.enable_vpc_flow_flogs ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Rol IAM que utilizará VPC Flow Logs para poder acceder la tráfico de red de la VPC y guardar los registros en CloudWatch
resource "aws_iam_role" "this" {
  count              = var.enable_vpc_flow_flogs ? 1 : 0
  name               = format("%s-vpc-flow-logs", local.vpc_name)
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

# Listados de permisos que se otorgarán al rol IAM
data "aws_iam_policy_document" "permissions" {
  count = var.enable_vpc_flow_flogs ? 1 : 0
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

# Asociación de los permisos anteriores al rol IAM
resource "aws_iam_role_policy" "this" {
  count  = var.enable_vpc_flow_flogs ? 1 : 0
  name   = format("%s-vpc-flow-logs", local.vpc_name)
  role   = aws_iam_role.this[0].id
  policy = data.aws_iam_policy_document.permissions[0].json
}

