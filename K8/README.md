## Keys 

To generate a private key and public keys you need to issue the commands:

```
openssl genpkey -algorithm RSA  -outform PEM -out SSH-Key.pem
chmod 0400 SSH-Key.pem
ssh-keygen -e -f SSH-Key.pem > public_key.pem
```

## NAT Gateway
The NAT Gateway is needed so the server can get to the internet, we need this to be able to install packages.

### Installation
Create an EIP in the VPC, but do not associate it at this time. 

```
resource "aws_eip" "natgw" {
  vpc      = true
}
```

then create a NAT Gateway in the **PUBLIC** subnet, it is advised to depend on the internet gateway being created before creating the NAT gateway.

```
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.main]
}
```

Now you have the gateway, you can add the route to your **PRIVATE** route table

```
resource "aws_route" "route_2" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

```

The server should now be able to access the internet, however there may be no SECURITY_GROUP egress rule on the server, which would prevent this, in that case you will need to add

```
resource "aws_security_group" "bastion" {
  ----
  ----
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
