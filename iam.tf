
resource "aws_iam_user" "awsiam" {
  name = "iamuser.${count.index}" 
  count = 3
  }

output "iam-arns"{
 value = aws_iam_user.awsiam[0].arn
}

