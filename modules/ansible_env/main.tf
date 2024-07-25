module "dev-vpc" {
  source = "../vpc"
}

resource "aws_instance" "ACN_Server" {

  ami                         = var.ami_id
  instance_type               = var.ansible_control_node_spec
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.dev-vpc.ansible_subnet_sg_id]
  key_name                    = var.key_name
  subnet_id                   = module.dev-vpc.ansible_subnet_id

  tags = {
    Name = "ACN-Server-${count.index + 1}"
  }

  user_data = file("${path.module}/files/acn.sh")

  count = 1

  depends_on = [module.dev-vpc]
}
resource "aws_instance" "Ansible_Client" {
  ami                         = var.ami_id
  instance_type               = var.ansible_client_spec
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.dev-vpc.ansible_subnet_sg_id]
  key_name                    = var.key_name
  subnet_id                   = module.dev-vpc.ansible_subnet_id

  tags = {
    Name = "Ansible-Client-${count.index + 1}"
  }

  user_data = file("${path.module}/files/ans-client.sh")

  count = 2
}
resource "aws_instance" "jumpbox" {
  ami                         = var.ami_id # Replace with a suitable AMI ID
  instance_type               = var.jumpbox_spec
  key_name                    = var.key_name # Replace with your key pair
  vpc_security_group_ids      = [module.dev-vpc.jumpbox_subnet_sg_id]
  associate_public_ip_address = true
  subnet_id                   = module.dev-vpc.jumpbox_subnet_id

  tags = {
    Name = "Jumpbox-Server"
  }

  user_data = file("${path.module}/files/ans-client.sh")

}
