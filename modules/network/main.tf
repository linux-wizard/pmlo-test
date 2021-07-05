data "aws_availability_zones" "available" {
  state                 = "available"
}

resource "aws_vpc" "pmlo-test-private-network-prod" {
  cidr_block            = "192.168.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  tags = {
    Name = "pmlo-test-private-network-prod"
  }
}

// Associate GW to the VPC
resource "aws_internet_gateway" "pmlo-test-gw-prod" {
  vpc_id                = "${aws_vpc.pmlo-test-private-network-prod.id}"
  tags = {
    Name = "pmlo-test-gw"
  }
}


// resource "aws_eip" "pmlo-test-eip" {
//     count = var.app_count
//     //instance = "${aws_instance.app_server.[${count.index}].id}"
//     vpc = true
//     depends_on = [aws_internet_gateway.pmlo-test-gw-prod]
// }


// subnet for application. this will be a public subnet with a public IP
resource "aws_subnet" "app-subnet" {
    cidr_block              = "${cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block,5,0)}"
    vpc_id                  = "${aws_vpc.pmlo-test-private-network-prod.id}"
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true
}

// route 0.0.0.0 -> gw
resource "aws_route_table" "pmlo-test-route-table-prod" {
    vpc_id                  = "${aws_vpc.pmlo-test-private-network-prod.id}"
    route {
        cidr_block          = "0.0.0.0/0"
        gateway_id          = "${aws_internet_gateway.pmlo-test-gw-prod.id}"
    }
    tags = {
        Name = "pmlo-test-route-prod"
    }
}

// Associate route table with VPC subnet
resource "aws_route_table_association" "subnet-association" {
  subnet_id                 = "${aws_subnet.app-subnet.id}"
  route_table_id            = "${aws_route_table.pmlo-test-route-table-prod.id}"
}


// subnet for RDS. this will be a private
resource "aws_subnet" "rds-subnet-1" {
    cidr_block              = "${cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block,5,20)}"
    vpc_id                  = "${aws_vpc.pmlo-test-private-network-prod.id}"
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false
}
resource "aws_subnet" "rds-subnet-2" {
    cidr_block              = "${cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block,5,21)}"
    vpc_id                  = "${aws_vpc.pmlo-test-private-network-prod.id}"
    availability_zone       = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false
}
resource "aws_subnet" "rds-subnet-3" {
    cidr_block              = "${cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block,5,22)}"
    vpc_id                  = "${aws_vpc.pmlo-test-private-network-prod.id}"
    availability_zone       = data.aws_availability_zones.available.names[2]
    map_public_ip_on_launch = false
}

// subnet for Elastic Search
// resource "aws_subnet" "app-subnet" {
//     cidr_block = "${cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block,4,0)}"
//     vpc_id      = "${aws_vpc.pmlo-test-private-network-prod.id}"
//     availability_zone = data.aws_availability_zones.available.name[0]
// }