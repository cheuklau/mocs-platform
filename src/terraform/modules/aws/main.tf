############################################################################
# Set AWS provider and key-pair
############################################################################

provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region = "${var.AWS_REGION}"
}

resource "aws_key_pair" "mykeypair" {
  key_name = "mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}

############################################################################
# Set AWS security groups
############################################################################

resource "aws_security_group" "open-security-group" {
  vpc_id = "${aws_vpc.main.id}"
  name = "open-security-group"
  description = "open security group allows all ingress and egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  tags {
    Name = "open-security-group"
  }
}

############################################################################
# Set up VPC, subnets, internet gateway, and route tables
############################################################################

# Main VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16" 
    instance_tenancy = "default"   # Instance runs on shared hardware
    enable_dns_support = "true"    # Amazon-provided DNS server enabled
    enable_dns_hostnames = "true"  # Amazon-provided DNS hostnames enabled
    enable_classiclink = "false"   # Do not allow EC2-classic instances
    tags {
        Name = "main"
    }
}

# Public subnet availability zone a
resource "aws_subnet" "main-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"        
    map_public_ip_on_launch = "true" 
    availability_zone = "${var.AWS_REGION}"+"a"
    tags {
        Name = "main-public-1"
    }
}

# Public subnet in us-west-2b
resource "aws_subnet" "main-public-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AWS_REGION}"+"b"
    tags {
        Name = "main-public-2"
    }
}

# Internet gateway
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "main"
    }
}

# Route table
resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }
    tags {
        Name = "main-public"
    }
}

# Route to public subnet in availability zone a
resource "aws_route_table_association" "main-public-1" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

# Route to public subnet in availability zone b
resource "aws_route_table_association" "main-public-2" {
    subnet_id = "${aws_subnet.main-public-2.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}