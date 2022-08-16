# set virtual private cloud (vpc)
resource "aws_vpc" "code_server_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# set up internet gateways to allow communication between the instance in the vpc and the external internet
resource "aws_internet_gateway" "code_server_gateway" {
  vpc_id = aws_vpc.code_server_vpc.id
}

# set up subnet, the instance will place in this subnet
resource "aws_subnet" "code_server_subnet" {
  vpc_id = aws_vpc.code_server_vpc.id
  # subnet's availability zone needs to be the same as instance's availability zone
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.0.0/24"
}

# set up the route table, enables network packets to flow in and out efficiently
resource "aws_route_table" "code_server_route_table" {
  vpc_id = aws_vpc.code_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.code_server_gateway.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.code_server_subnet.id
  route_table_id = aws_route_table.code_server_route_table.id
}

# set instance's public IP
resource "aws_eip" "code_server_public_ip" {
  instance = aws_instance.code_server.id
  vpc      = true
}
