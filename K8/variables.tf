variable "key_name" {
  default = "SSH-Key"
}


#
# Common Tags
#
variable "tags" {
  type = map(any)
  default = {
    "Owner" = "Steven Fawcett"
    "Email" = "steve.fawcett@capgemini.com"
    "Environment" = "Development"
  }
}
