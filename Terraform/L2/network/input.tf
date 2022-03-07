variable "common_tags" {
  type = map
  description = "A MAP of tags used by the resources"
  default = {
     Name = "Unknown"
  }

}

variable "vpc_cidr_block" {
  description = "CIDR block of VPC"
}

variable "private_cidr_block" {
  description = "CIDR block of Private Subnet"
}

variable "public_cidr_block" {
  description = "CIDR block of Public Subnet"
}
