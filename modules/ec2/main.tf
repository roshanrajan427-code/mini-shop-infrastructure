
resource "aws_security_group" "backend" {
  name                   = "MiniShopSec"
  description            = "created 2026-10-26T05:23:50.369Z"
  vpc_id                 = "vpc-04a0fc4bd4458faf6"
  revoke_rules_on_delete = false

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "backend" {
  ami                    = "ami-0c7632fb77f35db43"
  instance_type          = "t3.micro"
  subnet_id              = "subnet-046d32a00775021f1"
  key_name               = "mini-shop-key"
  vpc_security_group_ids = [aws_security_group.backend.id]
  iam_instance_profile   = var.instance_profile_name

  ebs_optimized = true
  monitoring    = false

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_protocol_ipv6          = "disabled"
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    encrypted             = false
    delete_on_termination = true
  }

  tags = {
    Name = "mini-shop-backend"
  }
}
