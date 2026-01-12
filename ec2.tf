resource "aws_instance" "tf_ec2" {
  ami           = "ami-0ef6d0055be7553ee"
  instance_type = "t3.medium"
  }
