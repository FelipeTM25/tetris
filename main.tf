provider "aws" {
  region = "us-east-1"  # Cambia a tu región AWS deseada
}
resource "aws_key_pair" "deployer_key" {
  key_name = "llaveTetris"
  public_key = file("~/.ssh/llaveTetris.pub")
}
# Creación de la VPC
resource "aws_vpc" "tetris_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Tetris-VPC"
  }
}

# Subnet Pública
resource "aws_subnet" "tetris_public_subnet" {
  vpc_id     = aws_vpc.tetris_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Cambia a tu AZ deseada
  tags = {
    Name = "Tetris-Publica"
  }
}

# Subnet Privada
resource "aws_subnet" "tetris_private_subnet" {
  vpc_id     = aws_vpc.tetris_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"  # Cambia a tu AZ deseada
  tags = {
    Name = "Tetris-Privada"
  }
}

# Security Group para la instancia EC2 en la subnet privada
resource "aws_security_group" "tetris_sg" {
  name        = "tetris-security-group"
  description = "Security group para la instancia Tetris"

  vpc_id = aws_vpc.tetris_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# Instancia EC2 en la subnet privada
resource "aws_instance" "tetris_instance" {
  ami           = "ami-0e001c9271cf7f3b9"  # Ubuntu 22.04 AMI, cambia según tu región y AMI
  instance_type = "t2.large"
  subnet_id     = aws_subnet.tetris_private_subnet.id
  key_name      = "llaveTetris"  # Cambia al nombre de tu llave pública en AWS

  security_groups = [aws_security_group.tetris_sg.id]

  tags = {
    Name = "Tetris-Instance"
  }
  user_data     =<<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install docker-compose -y
        git clone https://github.com/FelipeTM25/tetris.git
        cd tetris/
        sudo docker build -t apptetris:v01 .
        sudo docker run -d -p 3000:3000 apptetris:v01 npm start
        EOF
}

# Balanceador de Carga (Load Balancer)
resource "aws_lb" "tetris_lb" {
  name               = "tetris-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tetris_sg.id]
  subnets            = [aws_subnet.tetris_public_subnet.id]

  tags = {
    Name = "Tetris-Load-Balancer"
  }
}

# Asociar instancia EC2 al Target Group del Load Balancer
resource "aws_lb_target_group_attachment" "tetris_lb_attachment" {
  target_group_arn = aws_lb.tetris_lb.arn
  target_id        = aws_instance.tetris_instance.id
  port             = 3000
}
