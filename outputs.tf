output "jumpbox_server_ip" {
  description = "The public IP address of the Jumpbox instance"
  value       = module.ansible_env.jumpbox_public_ip
}