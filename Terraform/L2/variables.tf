variable instance_type {
   default = "t2.micro"
}

variable common_tags {
   type = map
   default = {
          "Project"  = "My Project"
          "Owner"    = "Steve Fawcett"
   }
}

variable public_cidr_block {
  default = "10.0.0.0/24"
}

variable private_cidr_block {
  default = "10.0.2.0/24"
}

variable var.vpc_cider_block {
  default = "10.0.0.0/16"
}
