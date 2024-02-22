output "subnet_id" {
  description = "ID da subnet criada na AWS"
  value       = aws_subnet.subnet_fasteats.id
}

output "security_group_id" {
  description = "ID do security_group criada na AWS"
  value       = aws_security_group.security_group_fasteats.id
}