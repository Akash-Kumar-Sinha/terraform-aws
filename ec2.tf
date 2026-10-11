resource "aws_key_pair" "deployer-ec2" {
  key_name   = "terra-ec2-key"
  public_key = file("terra-ec2-key.pub")
}

resource  "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress{
	from_port = 22
	to_port = 22
	protocol = "TCP"
	cidr_blocks = ["0.0.0.0/0"]
	description = "Allow SSH from anywhere"
  }
  ingress{
	from_port = 80
	to_port = 80
	protocol = "TCP"
	cidr_blocks = ["0.0.0.0/0"]
	description = "Allow HTTP from anywhere"
  }

  egress{
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	description = "Allow all outbound traffic"
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "app" {
  depends_on = [aws_security_group.allow_tls, aws_key_pair.deployer-ec2]
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.deployer-ec2.key_name
  security_groups = [aws_security_group.allow_tls.name]
  user_data = file("nginx.sh")

  root_block_device {
	volume_size = var.env == "prod" ? var.ec2_default_root_storage_size : 8
	volume_type = "gp3"
  }

  tags = {
	Name = "aws-ec2-app"
  }
}