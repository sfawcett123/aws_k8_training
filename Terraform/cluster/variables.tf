variable "common_tags" {
  type = map(any)
  default = {
    "Project" = "Cluster Project"
    "Owner"   = "Steve Fawcett"
    "GUID"    = "42dd912d-d217-42b2-895d-f7433be36204"
  }
}

variable "public_cidr_block" {
  default = "10.0.0.0/24"
}

variable "private_cidr_block" {
  default = "10.0.2.0/24"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
