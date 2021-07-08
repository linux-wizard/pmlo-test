data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "pmlo-test-private-network-prod" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "pmlo-test-private-network-prod"
  }
}



// subnet for application. this will be a public subnet with a public IP
resource "aws_subnet" "app-subnet" {
  count                   = 3
  cidr_block              = cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block, 5, 0 + count.index)
  vpc_id                  = aws_vpc.pmlo-test-private-network-prod.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

// Associate GW to the VPC
resource "aws_internet_gateway" "pmlo-test-gw-prod" {
  vpc_id = aws_vpc.pmlo-test-private-network-prod.id
  tags = {
    Name = "pmlo-test-gw"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "pmlo-test-internet_access" {
  route_table_id         = aws_vpc.pmlo-test-private-network-prod.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pmlo-test-gw-prod.id
}

resource "aws_eip" "nat" {
  count      = 3
  vpc        = true
  depends_on = [aws_internet_gateway.pmlo-test-gw-prod]
}

resource "aws_nat_gateway" "nat-gw" {
  count         = 3
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.app-subnet.*.id, count.index)
  // depends_on    = [aws_internet_gateway.pmlo-test-gw-prod]
}
// route 0.0.0.0 -> gw
// resource "aws_route_table" "pmlo-test-route-table-public-prod" {
//   vpc_id = aws_vpc.pmlo-test-private-network-prod.id
//   route {
//     cidr_block = "0.0.0.0/0"
//     gateway_id = aws_internet_gateway.pmlo-test-gw-prod.id
//   }
//   tags = {
//     Name = "pmlo-test-route-public-prod"
//   }
// }

// Associate route table with VPC subnet
// resource "aws_route_table_association" "subnet-association-public" {
//   count          = 3
//   subnet_id      = aws_subnet.app-subnet[count.index].id
//   route_table_id = aws_route_table.pmlo-test-route-table-public-prod.id
// }



// private subnet
resource "aws_subnet" "private" {
  count             = 3
  cidr_block        = cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block, 5, 10 + count.index)
  vpc_id            = aws_vpc.pmlo-test-private-network-prod.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

// // subnet for RDS. this will be a private
// resource "aws_subnet" "rds-subnet" {
//   count             = 3
//   cidr_block        = cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block, 5, 10 + count.index)
//   vpc_id            = aws_vpc.pmlo-test-private-network-prod.id
//   availability_zone = data.aws_availability_zones.available.names[count.index]
//   // map_public_ip_on_launch = true
// }

resource "aws_route_table" "private" {
  count  = 3
  vpc_id = aws_vpc.pmlo-test-private-network-prod.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat-gw.*.id, count.index)
  }
}

// resource "aws_route" "private" {
//   count                  = 3
//   route_table_id         = element(aws_route_table.private.*.id, count.index)
//   destination_cidr_block = "0.0.0.0/0"
//   nat_gateway_id         = element(aws_nat_gateway.nat-gw.*.id, count.index)
// }

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}