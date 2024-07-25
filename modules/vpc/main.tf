resource "aws_vpc" "dev" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr

  tags = {
    name = var.vpc_name
  }
}
resource "aws_internet_gateway" "dev_vpc_igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = var.igw_name
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

  depends_on = [aws_subnet.jumpbox_subnet]
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

  depends_on = [aws_subnet.ansible_subnet]
}
