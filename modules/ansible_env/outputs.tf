output "jumpbox_public_ip" {
  description = "The public IP address of the Jumpbox instance"
  value       = aws_instance.jumpbox.public_ip
}
