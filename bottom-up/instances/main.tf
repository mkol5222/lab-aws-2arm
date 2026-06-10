data "aws_ami" "ubuntu_lts" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = [var.ubuntu_ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = [var.instance_architecture]
  }
}

resource "aws_subnet" "vm_subnets" {
  for_each = toset(var.availability_zones)

  vpc_id                  = var.vpc_id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_newbits, var.vm_subnet_netnums[each.key])
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.deployment_prefix}-vm-subnet-${each.key}"
  }
}

resource "aws_vpc_endpoint" "gwlbe" {
  for_each = aws_subnet.vm_subnets

  vpc_id            = var.vpc_id
  service_name      = var.gwlb_service_name
  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = [each.value.id]

  tags = {
    Name = "${var.deployment_prefix}-gwlbe-${each.key}"
  }
}

resource "aws_route_table" "vm_subnets" {
  for_each = aws_subnet.vm_subnets

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.deployment_prefix}-vm-subnet-${each.key}-rtb"
  }
}

resource "aws_route" "vm_default_to_gwlbe" {
  for_each = aws_route_table.vm_subnets

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[each.key].id
}

resource "aws_route_table_association" "vm_subnets" {
  for_each = aws_subnet.vm_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.vm_subnets[each.key].id
}

resource "aws_route_table" "internet_gateway_ingress" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.deployment_prefix}-vm-subnet-igw-ingress-rtb"
  }
}

resource "aws_route" "internet_gateway_ingress_to_gwlbe" {
  for_each = aws_subnet.vm_subnets

  route_table_id         = aws_route_table.internet_gateway_ingress.id
  destination_cidr_block = each.value.cidr_block
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[each.key].id
}

resource "aws_route_table_association" "internet_gateway_ingress" {
  gateway_id     = var.internet_gateway_id
  route_table_id = aws_route_table.internet_gateway_ingress.id
}

resource "aws_security_group" "ubuntu" {
  name        = "${var.deployment_prefix}-ubuntu-vm-sg"
  description = "Security group for Ubuntu egress inspection demo VM"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed CIDRs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_cidrs
  }

  egress {
    description = "All outbound traffic for egress inspection demo"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_prefix}-ubuntu-vm-sg"
  }
}

resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ami.ubuntu_lts.id
  instance_type               = var.instance_type
  key_name                    = var.sshkey_name
  subnet_id                   = aws_subnet.vm_subnets[var.availability_zones[0]].id
  vpc_security_group_ids      = [aws_security_group.ubuntu.id]
  associate_public_ip_address = true
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/ubuntu-user-data.yaml", {
    ubuntu_password = var.ubuntu_password
  })

  tags = {
    Name = "${var.deployment_prefix}-ubuntu-egress-test"
  }
}