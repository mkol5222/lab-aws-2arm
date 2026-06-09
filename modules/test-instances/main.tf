data "aws_subnet" "selected" {
  for_each = var.subnet_ids

  id = each.value
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "test_instances" {
  name_prefix = "test-instances-"
  description = "Security group for test instances"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "test-instances-sg"
  })
}

resource "aws_instance" "test_instances" {
  for_each = var.subnet_ids

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.test_instances.id]
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = <<-CLOUDCONFIG
              #cloud-config
              hostname: test-instance-${each.key}
              ssh_pwauth: true
              disable_root: true
              chpasswd:
                expire: false
                users:
                  - name: ubuntu
                    password: ${var.ubuntu_password}
                    type: text
              write_files:
                - path: /etc/default/grub.d/99-ec2-serial.cfg
                  permissions: '0644'
                  content: |
                    GRUB_CMDLINE_LINUX_DEFAULT="$${GRUB_CMDLINE_LINUX_DEFAULT} console=tty1 console=ttyS0,115200n8"
                    GRUB_TERMINAL="console serial"
                    GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
              runcmd:
                - cloud-init-per once update-grub update-grub
                - systemctl enable serial-getty@ttyS0.service
                - systemctl restart serial-getty@ttyS0.service
              CLOUDCONFIG

  tags = merge(var.tags, {
    Name             = "test-instance-${each.key}"
    AvailabilityZone = data.aws_subnet.selected[each.key].availability_zone
  })
}