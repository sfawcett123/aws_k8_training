resource "aws_secretsmanager_secret" "secretmasterDB" {
   name = "SSH_key"

   tags = var.common_tags
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = tls_private_key.private_key.private_key_pem
}

resource "aws_iam_policy" "policy" {
  name        = "ssh_key_policy"
  path        = "/"
  description = "Allow Read Access to SSH Key"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource":  aws_secretsmanager_secret.secretmasterDB.arn
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        }
    ] } )
}
