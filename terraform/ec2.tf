# instance type has a corresponding availability zone in each region
# here the availability zones are filtered by the resource aws_availability_zones
# ref: https://aws.amazon.com/tw/premiumsupport/knowledge-center/ec2-instance-type-not-supported-az-error/
data "aws_availability_zones" "available" {
  state = "available"
}

# filter option can refer to aws cli "describe-images"
# ref: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "code_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t4g.small"
  # set ssh key pair of remote instance
  key_name          = aws_key_pair.code_server_key_pair.key_name
  security_groups   = [aws_security_group.code_server_security_group.id]
  availability_zone = data.aws_availability_zones.available.names[0]
  # when instance launched, excute the configuration tasks
  user_data_base64            = data.template_cloudinit_config.setup.rendered
  user_data_replace_on_change = true

  tags = {
    Name = "code_server"
  }

  # set elatic block storage (EBS)
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
  }

  # place the instance in the specified subnet
  subnet_id = aws_subnet.code_server_subnet.id
}

data "template_cloudinit_config" "setup" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "setup.sh"
    content_type = "text/x-shellscript"
    content      = file("setup.sh")
  }
}

# set security groups, similar to firewall
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

# set ssh key pair to connect the instance
resource "aws_key_pair" "code_server_key_pair" {
  key_name   = "code_server"
  public_key = file(var.ssh_public_key_filepath)
}
