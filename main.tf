resource "aws_vpc" "dev" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.cidr

  tags = {
    name = "dev-vpc"
  }
}
resource "aws_internet_gateway" "dev_vpc_igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_vpc_igw.id
  }

  tags = {
    Name = "dev-route-table"
  }
}

# Make the route table as main route table replacing default
resource "aws_main_route_table_association" "dev-main-route-table" {
  vpc_id         = aws_vpc.dev.id
  route_table_id = aws_route_table.dev-route-table.id
}

resource "aws_instance" "ACN_Server" {
  ami                         = var.ami_id
  instance_type               = var.ansible_control_node_spec
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ansible_subnet_sg.id]
  subnet_id                   = aws_subnet.ansible_subnet.id
  key_name                    = var.key_name

  tags = {
    Name = "ACN-Server-${count.index + 1}"
  }

  user_data = file("files/user_data.sh")

  count = 1
}
resource "aws_instance" "Ansible_Client" {
  ami                         = var.ami_id
  instance_type               = var.ansible_client_spec
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ansible_subnet_sg.id]
  subnet_id                   = aws_subnet.ansible_subnet.id
  key_name                    = var.key_name

  tags = {
    Name = "Ansible-Client-${count.index + 1}"
  }

  user_data = file("files/user_data.sh")

  count = 3
}
resource "aws_instance" "jumpbox" {
  ami                         = var.ami_id # Replace with a suitable AMI ID
  instance_type               = var.jumpbox_spec
  key_name                    = var.key_name                 # Replace with your key pair
  subnet_id                   = aws_subnet.jumpbox_subnet.id # Replace with your subnet ID
  vpc_security_group_ids      = [aws_security_group.jumpbox_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jumpbox-Server"
  }

  user_data = file("files/user_data.sh")

}
resource "aws_subnet" "ansible_subnet" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Ansible Subnet"
  }
  depends_on = [aws_vpc.dev]
}
resource "aws_subnet" "jumpbox_subnet" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Jumpbox Subnet"
  }
  depends_on = [aws_vpc.dev]
}
resource "aws_security_group" "jumpbox_sg" {
  name        = "jumpbox_sg"
  description = "Allow SSH access to jumpbox"
  vpc_id      = aws_vpc.dev.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["180.75.236.53/32"] # Replace with your IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ansible_subnet_sg" {
  name        = "Ansible_Subnet_SG"
  description = "Allow SSH access for Ansible use"
  vpc_id      = aws_vpc.dev.id


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jumpbox_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
