output "jumpbox_server_ip" {
  description = "IP of the Jump Box Server"
  value       = aws_instance.jumpbox.public_ip
}