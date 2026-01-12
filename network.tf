provider "aws" {
  region = "ap-southeast-2"

}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true # DNS resolution
  enable_dns_hostnames = true # DNS hostnames

  tags = {
    Name = "tf-vpc"
  }
}

output "vpc-info" {
  value = aws_vpc.tf_vpc.id


}


# 2. Subnet 1: tf-private-1 (10.1.0.0/24) in apse2-az1
resource "aws_subnet" "tf_private_1" {
  vpc_id               = aws_vpc.tf_vpc.id
  cidr_block           = "10.1.0.0/24"
  availability_zone_id = "apse2-az1"

  tags = {
    Name = "tf-private-1"
  }
}

# 3. Subnet 2: tf-private-2 (10.1.1.0/24) in apse2-az3
resource "aws_subnet" "tf_private_2" {
  vpc_id               = aws_vpc.tf_vpc.id
  cidr_block           = "10.1.1.0/24"
  availability_zone_id = "apse2-az3"

  tags = {
    Name = "tf-private-2"
  }
}

# 4. Subnet 3: tf-public-1 (10.1.2.0/24) in apse2-az1
resource "aws_subnet" "tf_public_1" {
  vpc_id               = aws_vpc.tf_vpc.id
  cidr_block           = "10.1.2.0/24"
  availability_zone_id = "apse2-az1"

  map_public_ip_on_launch = true # typical for public subnets

  tags = {
    Name = "tf-public-1"
  }
}

# 5. Internet gateway attached to tf-vpc
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf-igw"
  }
}

# 6. Private route table: tf-private-rt (for tf-private-1 & tf-private-2)
resource "aws_route_table" "tf_private_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf-private-rt"
  }
}

# Associate private subnets with tf-private-rt
resource "aws_route_table_association" "tf_private_1_assoc" {
  subnet_id      = aws_subnet.tf_private_1.id
  route_table_id = aws_route_table.tf_private_rt.id
}

resource "aws_route_table_association" "tf_private_2_assoc" {
  subnet_id      = aws_subnet.tf_private_2.id
  route_table_id = aws_route_table.tf_private_rt.id
}

# 7. Public route table: tf-public-rt (for tf-public-1)
resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf-public-rt"
  }
}

resource "aws_route_table_association" "tf_public_1_assoc" {
  subnet_id      = aws_subnet.tf_public_1.id
  route_table_id = aws_route_table.tf_public_rt.id
}

# 8. Route 0.0.0.0/0 in tf-private-rt to Internet Gateway
resource "aws_route" "tf_private_default_route" {
  route_table_id         = aws_route_table.tf_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_igw.id
}
# 8. Route 0.0.0.0/0 in tf-public-rt to Internet Gateway
resource "aws_route" "tf_public_default_route" {
  route_table_id         = aws_route_table.tf_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_igw.id
}
