terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">=1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

variable "lab_count" {
  type    = number
  default = 4
}

variable "instance_type" {
  type    = string
  default = "t3a.medium"
}

variable "instance_ami" {
  type    = string
  default = "ami-097104a26f5e1c26a"
}

variable "zoneid" {
  type    = string
  default = "ZQLGJF1OAQCSD"
}

variable "ws_name" {
  type    = string
  default = "Workshop Name"
}

variable "ws_id" {
  type    = string
  default = "dde98b"
}

variable "instances" {
  type    = list(string)
  default = ["rocky", "bullwinkle", "boris", "natasha"]
}

resource "aws_vpc" "vpc" {
  cidr_block           = "172.17.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.ws_id}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

resource "aws_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.ws_id}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0"
  to_port           = 22
  from_port         = 22
  ip_protocol       = "tcp"
  tags = {
    Name        = "${var.ws_id}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "code-server" {
  security_group_id = aws_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0"
  to_port           = 8080
  from_port         = 8080
  ip_protocol       = "tcp"
  tags = {
    Name        = "${var.ws_id}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.default.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  tags = {
    Name        = "${var.ws_id}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.17.10.0/24"
  tags = {
    Name        = "${var.ws_id}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "${var.ws_id}-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/MvDOG+BPQtOaG053iV5vy8IFk1cQt9B2xPewI7Uxuys8XN9yC3b/frMsX9cXPoZc5N9jOvCw3W9JPahpYblv6IldVeKab6XLCJJOHwZnX9sbyoIcx8oXxUNnwytLPIE9bEadsRYVQudDJ34zO0Yh4PzTfMttnLq+LYX9/N7w3l24VX1PwTBaecDivieSh9FLtioJvm+exN6k4CM6V3LtiOkrchj3jkrB9yh69KynckkO51ZQwASbwxqkLe+drFdrFP7WaCLhs1Z/UmiRpIV9g/zj5jIwkn9DeOKDeLPwk1lJ10AVCoGNXyPh+/CDEq2U0tvuea+4ARv7nawbpCEnLegdfD3b0SpLpO1Ozy2zUJshoDQivUU4Aar6ms0EI37GX6h1OHbpDJV3rQUc2xNU9rjBdUP+cyKpOMpBwO9I35HFFb/FdU7+DfUK2y0iOAHNb0islyRgR8dqgRpDLTgd8fwoCRhj8Iz8gZZaX26WpZqWtutfEmsWEP+0NV09gqE="
  tags = {
    Name        = "${var.ws_id}"
    Workshop    = "${var.ws_name}"
    Workshop_ID = "${var.ws_id}"
  }
}

module "create-vms" {
  source = "./modules/create-vms"
  count  = var.lab_count

  lab_index     = count.index
  instance_ami  = var.instance_ami
  instance_type = var.instance_type
  key_name      = "${var.ws_name}-keypair"
  ws_name       = var.ws_name
  ws_id         = var.ws_id
  instances     = var.instances
}
