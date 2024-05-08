terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg-22-443-80-8080" {
  name = "terra-jenkins-SG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Jenkins" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.medium"
  key_name               = "jenkins-key"
  vpc_security_group_ids = [aws_security_group.sg-22-443-80-8080.id] // Attaches newly created security group to the instance
  user_data              = templatefile("./ec2_install.sh", {})

  root_block_device {
    volume_size = 20 // Specifies the storage size as 20 GB
  }

  tags = {
    Name = "Jenkins-server"
  }
}

# Other resource declarations...
output "public_ip" {
  value = aws_instance.Jenkins.public_ip //e.g: ssh -i "key_name.pem" ubuntu@<your-public-ip>
}
output "private_ip" {
  value = aws_instance.Jenkins.private_ip
}