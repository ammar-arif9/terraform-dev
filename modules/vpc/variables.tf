variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "Dev-VPC"
}
variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
  default     = "10.0.0.0/16"
}
variable "igw_name" {
  description = "IGW Name"
  type        = string
  default     = "Dev-IGW"
}