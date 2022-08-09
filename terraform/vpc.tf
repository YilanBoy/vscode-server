# 設定虛擬私有雲端 (Virtual Private Cloud, VPC)
resource "aws_vpc" "code_server_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# 設定網際網路閘道，讓 VPC 中的執行個體可以與外部網際網路之間進行通訊
resource "aws_internet_gateway" "code_server_gateway" {
  vpc_id = aws_vpc.code_server_vpc.id
}

# 建立子網路，EC2 instance 會放在此子網路中
resource "aws_subnet" "code_server_subnet" {
  vpc_id = aws_vpc.code_server_vpc.id
  # Subnet 需要與 Instance 的 Availability Zone 相同
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.0.0/24"
}

# 設定路由表，讓網路封包可以有效流入流出
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

# 設定 EC2 instance 的 public IP
resource "aws_eip" "code_server_public_ip" {
  instance = aws_instance.code_server.id
  vpc      = true
}
