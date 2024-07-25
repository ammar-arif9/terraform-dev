output "ansible_subnet_sg_id" {
  description = "The ID of the ansible security group"
  value       = aws_security_group.ansible_subnet_sg.id
}
output "jumpbox_subnet_sg_id" {
  description = "The ID of the ansible security group"
  value       = aws_security_group.jumpbox_sg.id
}
output "ansible_subnet_id" {
  description = "The ID of the ansible security group"
  value       = aws_subnet.ansible_subnet.id
}
output "jumpbox_subnet_id" {
  description = "The ID of the ansible security group"
  value       = aws_subnet.jumpbox_subnet.id
}