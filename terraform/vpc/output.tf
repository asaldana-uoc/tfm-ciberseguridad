output "vpc_id" {
  description = "Identificador del VPC creado"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Identificadores de las subredes públicas creadas en el VPC"
  value       = [for subnet in keys(var.public_subnets) : aws_subnet.public[subnet].id]
}

output "private_subnet_ids" {
  description = "Identificadores de las subredes privadas creadas en el VPC"
  value       = [for subnet in keys(var.private_subnets) : aws_subnet.private[subnet].id]
}

output "nat_gateway_ip" {
  description = "Dirección IP de la NAT Gateway"
  value       = aws_nat_gateway.this[0].public_ip
}

