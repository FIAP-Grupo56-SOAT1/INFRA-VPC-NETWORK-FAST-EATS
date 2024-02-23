output "vpc_id" {
  description = "ID VPC FASTEATS"
  value       = aws_vpc.vpc_fasteats.id
}

output "subnet_privada_id" {
  description = "ID da subnet criada na AWS"
  value       = aws_subnet.subnet_fasteats_privada.id
}

output "subnet_publica_id" {
  description = "ID da subnet publica criada na AWS"
  value       = aws_subnet.subnet_fasteats_publica.id
}

output "security_group_id" {
  description = "ID do security_group criada na AWS"
  value       = aws_security_group.security_group_fasteats.id
}