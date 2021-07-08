// subnet for RDS. this will be a private
// resource "aws_subnet" "xwiki" {
//   count                   = 2
//   cidr_block              = cidrsubnet(aws_vpc.pmlo-test-private-network-prod.cidr_block, 5, 20 + count.index)
//   vpc_id                  = aws_vpc.pmlo-test-private-network-prod.id
//   availability_zone       = data.aws_availability_zones.available.names[count.index]
//   map_public_ip_on_launch = false
// }