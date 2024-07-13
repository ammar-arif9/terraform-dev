resource "aws_instance" "LinuxServer" {
  ami                    = "ami-097c4e1feeea169e5"
  instance_type          = "t2.micro"
  associate_public_ip_address = false
  security_groups = [ "sg-056f9db2d12ce058e" ]
  subnet_id = "subnet-03fcfcc77d740d3fd"

  tags = {
    Name = "test-server${count.index + 1}"
  }

  count = 3
}

resource "aws_security_group" "jumpbox_sg" {
  name        = "jumpbox_sg"
  description = "Allow SSH access to jumpbox"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["180.75.236.53/32"]  # Replace with your IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jumpbox" {
  ami                    = "ami-097c4e1feeea169e5"  # Replace with a suitable AMI ID
  instance_type          = "t2.nano"
  key_name               = "jumpbox-key"  # Replace with your key pair
  subnet_id              = "subnet-xxxxxxxx"  # Replace with your subnet ID
  vpc_security_group_ids = [aws_security_group.jumpbox_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "jumpbox-server"
  }
}
