variable "port-ssl" {
  default     = "1443"
  description = "Only use for custom web server port"

}
resource "aws_vpc_security_group_ingress_rule" "tf-ec2-sg-in-1" {
  security_group_id = aws_security_group.tf-ec2-sg.id
  cidr_ipv4         = "10.0.0.0/8"
  from_port         = var.port-ssl
  ip_protocol       = "tcp"
  to_port           = var.port-ssl
}

resource "aws_vpc_security_group_egress_rule" "tf-ec2-sg-eg-1" {
  security_group_id = aws_security_group.tf-ec2-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "tf-ec2-sg" {
  name        = "allow_tls"
  description = "Allow WEB inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id


  tags = {
    Name = "for ec2"
  }
}

