resource "aws_eip" "eip_nat_gateway" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_nat_gateway.id
  subnet_id = var.public_subnet_id 
  tags = {
    Name = var.nat_name
  }
}