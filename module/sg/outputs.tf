output "vpc_security_group_ids" {
  value = aws_security_group.application.id
}
output "security_group_id" {
  value = [aws_security_group.database.id, ]
}

output "loadbalancer_group_id" {
value = aws_security_group.loadbalancer.id
}