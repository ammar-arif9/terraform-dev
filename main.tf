module "vpc" {
  source                    = "./modules/vpc"
}
module "ansible_env" {
  source                    = "./modules/ansible_env"
  ami_id                    = "ami-0f5bb6784895a7d47"
  ansible_control_node_spec = "t2.small"
  ansible_client_spec       = "t2.micro"
  jumpbox_spec              = "t2.nano"
  key_name                  = "jumpbox_key"

  depends_on = [ module.vpc ]

}