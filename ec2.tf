resource "aws_security_group" "tf_rdp_sg" {
  name        = "tf-rdp-sg"
  description = "Allow RDP - Changes been done from local"
  vpc_id      = aws_vpc.tf_vpc.id

  # Inbound RDP
  ingress {
    description      = "RDP from anywhere"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  # Outbound: allow all
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tf-rdp-sg"
  }
}
resource "aws_instance" "tf_ec2" {
  ami           = "ami-0ef6d0055be7553ee"
  instance_type = "t3.medium"

  subnet_id = aws_subnet.tf_public_1.id
  vpc_security_group_ids = [
    aws_security_group.tf_rdp_sg.id
  ]

  key_name                    = "tf-keypair"
  associate_public_ip_address = true
  tags = {
    Name = "tf-ec2"
  }
  

}
