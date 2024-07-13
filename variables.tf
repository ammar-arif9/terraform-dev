variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "dev-vpc"
}
variable "cidr" {
  description = "VPC Name"
  type        = string
  default     = "10.0.0.0/16"
}
variable "key_name" {
  description = "VPC Name"
  type        = string
  default     = "jumpbox_key"
}
variable "ami_id" {
  description = "Ami ID"
  type        = string
}
variable "jumpbox_spec" {
  description = "Instance type for jumpbox"
  type        = string
}
variable "ansible_control_node_spec" {
  description = "Instance type for Ansible control node"
  type        = string
}
variable "ansible_client_spec" {
  description = "Instance type for Ansible client"
  type        = string
}