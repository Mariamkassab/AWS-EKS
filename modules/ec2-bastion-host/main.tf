resource "aws_instance" "bastion_host" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  subnet_id = var.pub_subnet
  vpc_security_group_ids = var.bastion-host-security-group 
  key_name = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  tags = {
    Name = "bastion_host"
  }
}


resource "tls_private_key" "tls_private_k" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ec2-key"
  public_key = tls_private_key.tls_private_k.public_key_openssh
}


resource "local_file" "private_key_file" {
  filename = "./ec2-key.pem"
  content  = tls_private_key.tls_private_k.private_key_pem
}