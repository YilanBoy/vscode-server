# Instance Type 在各地區都有對應的 Availability Zone
# 這裡透過 aws_availability_zones 過濾出可以使用的 Availability Zone
# ref: https://aws.amazon.com/tw/premiumsupport/knowledge-center/ec2-instance-type-not-supported-az-error/
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "code_server" {
  ami           = var.ami
  instance_type = var.instance_type
  # 設定遠端連上 instance 的 key pair
  key_name          = aws_key_pair.code_server_key_pair.key_name
  security_groups   = [aws_security_group.code_server_security_group.id]
  availability_zone = data.aws_availability_zones.available.names[0]
  # 啟動 Instance 後，在 Instance 執行指令
  user_data = file("./script.sh")

  tags = {
    Name = "code_server"
  }

  # 設定 instance 的容量 (Elatic Block Storage, EBS)
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
  }

  # 將 intance 放入指定的子網路中
  subnet_id = aws_subnet.code_server_subnet.id
}

# 設定 security groups，用途類似於防火牆，可以用來決定 inbound 與 outbound 的規則
resource "aws_security_group" "code_server_security_group" {
  name   = "code_server"
  vpc_id = aws_vpc.code_server_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 設定用來連線 instance 的 key pair
resource "aws_key_pair" "code_server_key_pair" {
  key_name   = "code_server"
  public_key = file(var.ssh_public_key_filepath)
}
