# terraform-dev

Structure:

2 modules:

- Ansible env module
- VPC Module


What will be created:

- New VPC
- 2 type of SGs for jumpbox and ansible instances
- 1 IGW
- 1 route table replacing main route table and associate the created IGW
- 2 Ansible Client Node
- 1 Ansible Control Node
- 1 Jumpbox VM
