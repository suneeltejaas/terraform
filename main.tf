provider "aws" {
  region = "us-west-2"
}
resource "aws_security_group" "botx_apis" {
  name        = "test"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc
}

resource "aws_instance" "app" {
    ami                         = var.ami
    instance_type               = var.instancetype
    subnet_id                   = var.subnet
    associate_public_ip_address = true
    user_data                   = file("user-data.sh")
    key_name                    = var.keypair
}

resource "aws_ebs_volume" "data_volume" {
    availability_zone = aws_instance.app.availability_zone
    size              = var.addlDiskSizeinGB
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data_volume.id
  instance_id = aws_instance.app.id
}

output "ip" {
  value = aws_instance.app.private_ip
}
