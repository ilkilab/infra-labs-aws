resource "aws_vpc" "main" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "formation_${var.user_number}"
    DoNotDelete = "true"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.30.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_${var.user_number}"
    DoNotDelete = "true"
  }
}

resource "aws_instance" "instance" {
  for_each               = toset(var.instance_names)
  user_data = <<EOF
#!/bin/bash
hostname ${each.key}
echo ${each.key} > /etc/hostname
EOF
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = var.public_key
  root_block_device {
    volume_size = 30
  }
  source_dest_check = false
  tags = {
    Name = each.value
    DoNotDelete = "true"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gw_${var.user_number}"
    DoNotDelete = "true"
  }
}

resource "aws_route" "r" {
  route_table_id         = data.aws_route_table.selected.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_security_group" "allow_http" {
  vpc_id      = aws_vpc.main.id
  name        = "sg_${var.user_number}"
  description = "CKA"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}