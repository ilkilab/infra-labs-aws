data "aws_ami" "ubuntu" {
  owners      = [var.ami_owner]
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami]
  }
}

data "aws_route_table" "selected" {
  vpc_id = aws_vpc.main.id
}
