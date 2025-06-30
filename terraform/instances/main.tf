resource "aws_instance" "public" {
  count         = var.public_instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[count.index]
  key_name      = var.key_name
  security_groups = [var.public_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "public-instance-${count.index + 1}"
  }
}

resource "aws_instance" "private" {
  count         = var.private_instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_ids[count.index]
  key_name      = var.key_name
  security_groups = [var.private_sg_id]

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}
