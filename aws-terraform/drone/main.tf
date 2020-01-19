resource "aws_instance" "drone" {
  instance_type          = "t2.micro"
  ami                    = "ami-0d5d9d301c853a04a"
  user_data              = file("user_data.sh")
  vpc_security_group_ids = [aws_security_group.web_sec_group.id]
  key_name               = "aws_pub_key"
  tags                   = {
                    Name = "drone"
  }
}

resource "aws_security_group" "web_sec_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "aws_pub_key" {
    key_name   = "aws_pub_key"
    public_key = "${file("/root/.ssh/aws_public_key.pub")}"
}