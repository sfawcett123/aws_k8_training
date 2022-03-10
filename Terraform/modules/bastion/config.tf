locals {
  template_variables = {
    guid = var.tags.GUID 
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/init.cfg.tmp", local.template_variables)
  }

  part {
    filename     = "aws_ec2.yaml"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/templates/aws_ec2.yaml.tmp", local.template_variables)
  }

  part {
    filename     = "ansible.cfg"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/templates/ansible.cfg.tmp", local.template_variables)
  }
}
