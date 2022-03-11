variable "subnet_id" {}

variable "key_pair_name" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "ami_name" {
  default = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
}

variable "ami_virtualization_type" {
  default = ["hvm"]
}

variable "ami_owners" {
  default = ["099720109477"]
}

variable "nodes" {
  default = 2
}

