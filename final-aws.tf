provider "aws" {
        access_key = "AKIA2NIBY3N5MQOJHKKE"
        secret_key = "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"        
        region     = "ap-northeast-1"
}

resource "aws_vpc" "dev" {
  cidr_block           = "113.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "user13-Final-dev"
  }
}

resource "aws_subnet" "subnet-a" {
  vpc_id            = "${aws_vpc.dev.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block        = "113.0.1.0/24"

  tags = {
    Name = "user13-Final-subnet-a"
  }
}

resource "aws_subnet" "subnet-b" {
  vpc_id            = "${aws_vpc.dev.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block        = "113.0.2.0/24"

  tags = {
    Name = "user13-Final-subnet-b"
  }
}

resource "aws_subnet" "subnet-c" {
  vpc_id            = "${aws_vpc.dev.id}"
  availability_zone = "ap-northeast-1c"
  cidr_block        = "113.0.3.0/24"

  tags = {
    Name = "user13-Final-subnet-c"
  }
}

resource "aws_internet_gateway" "dev" {
  vpc_id = "${aws_vpc.dev.id}"

  tags = {
    Name = "user13-Final-dev"
  }
}

resource "aws_eip" "nat_dev_1a" {
  vpc = true
}

resource "aws_eip" "nat_dev_1b" {
  vpc = true
}

resource "aws_eip" "nat_dev_1c" {
  vpc = true
}

# dev_public
resource "aws_route_table" "dev_public" {
  vpc_id = "${aws_vpc.dev.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev.id}"
  }

  tags = {
    Name = "user13-Final-dev-public"
  }
}

resource "aws_route_table_association" "dev_subnet-a" {
  subnet_id      = "${aws_subnet.subnet-a.id}"
  route_table_id = "${aws_route_table.dev_public.id}"
}

resource "aws_route_table_association" "dev_subnet-b" {
  subnet_id      = "${aws_subnet.subnet-b.id}"
  route_table_id = "${aws_route_table.dev_public.id}"
}


resource "aws_route_table_association" "dev_subnet-c" {
  subnet_id      = "${aws_subnet.subnet-c.id}"
  route_table_id = "${aws_route_table.dev_public.id}"
}

resource "aws_default_network_acl" "dev_default" {
  default_network_acl_id = "${aws_vpc.dev.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [
    "${aws_subnet.subnet-a.id}",
    "${aws_subnet.subnet-b.id}",
   "${aws_subnet.subnet-c.id}",
  ]

  tags = {
    Name = "user13-Final-dev-default"
  }
}



resource "aws_default_security_group" "dev_default" {
  vpc_id = "${aws_vpc.dev.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "user13-Final-dev-default"
  }
}


