data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
  }
}

resource "aws_key_pair" "admin_key" {
  key_name = "key-cyber-linux"
  public_key = file("../ssh-key.pub")
}

resource "aws_instance" "K3s_master" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [aws_security_group.allow_ssh_netbird.id]

  key_name = aws_key_pair.admin_key.key_name


  lifecycle {
    ignore_changes = [ami] # Empêche le remplacement forcé si l'AMI change 
  }


  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              EOF

  tags = {
    Name = "k3s-master-aws"
  }
}
