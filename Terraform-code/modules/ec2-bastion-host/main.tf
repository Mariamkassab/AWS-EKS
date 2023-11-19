resource "aws_instance" "bastion_host" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  subnet_id = var.pub_subnet
  vpc_security_group_ids = var.bastion-host-security-group 
  key_name = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true
  user_data = file ( "./modules/userdata.tpl" )
  iam_instance_profile = aws_iam_instance_profile.ecr-access.name
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

resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ecr-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.ec2-role.name
}

resource "aws_iam_instance_profile" "ecr-access" {
  name = "ecr-access"
  role = aws_iam_role.ec2-role.name
}