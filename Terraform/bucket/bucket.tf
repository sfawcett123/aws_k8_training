provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::175965390220:role/OrganizationEngineerAccessRole"
  }
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "sf.k8.terraform.s3"
}
