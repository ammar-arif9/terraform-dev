module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"  # Specify the version of the module

  # Define the necessary variables for the module
  name = var.vpc_name
  cidr = var.cidr

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
