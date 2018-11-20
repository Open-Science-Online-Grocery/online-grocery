provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
  version    = "~> 1.18"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "database_user" {
  default = ""
}

variable "database_password" {
  default = ""
}

variable "vpc_cidr" {}

variable "vpc_public_subnets" {
  type = "list"
}

variable "vpc_private_subnets" {
  type = "list"
}

variable "vpc_database_subnets" {
  type = "list"
}

locals {
  project = "howes-grocery"
}

data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7*"]
  }

  owners = ["679593333241"]
}

resource "aws_instance" "howes_grocery" {
  ami                    = "${data.aws_ami.centos7.id}"
  instance_type          = "t2.small"
  subnet_id              = "${module.vpc.public_subnets[0]}"
  vpc_security_group_ids = ["${module.howes_grocery_sg.this_security_group_id}"]
  key_name               = "howes_grocery-staging"

  tags {
    Name = "${local.project}-${terraform.workspace}"
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = 2
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "com-${local.project}-${terraform.workspace}"
  acl    = "private"

  tags {
    Name = "com-${local.project}-${terraform.workspace}"
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Id": "${local.project}-${terraform.workspace}-policy",
   "Statement": [
     {
       "Sid": "Access-to-specific-VPCE-only",
       "Action": "s3:*",
       "Effect": "Allow",
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.bucket.id}",
                    "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"],
       "Condition": {
         "StringEquals": {
           "aws:sourceVpce": "${module.vpc.vpc_endpoint_s3_id}"
         }
       },
       "Principal": "*"
     }
   ]
}
POLICY
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "1.30.0"
  name                 = "${local.project}-${terraform.workspace}"
  cidr                 = "${var.vpc_cidr}"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  public_subnets       = "${var.vpc_public_subnets}"
  private_subnets      = "${var.vpc_private_subnets}"
  database_subnets     = "${var.vpc_database_subnets}"
  enable_s3_endpoint   = true
  enable_dns_hostnames = true
}

module "howes_grocery_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.23.0"

  name        = "${local.project}-${terraform.workspace}"
  description = "Security group for ${local.project}-${terraform.workspace}"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]

  ingress_with_self = [{
    from_port = 0
    to_port   = 0
    protocol  = -1
  }]

  egress_rules = ["all-all"]
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "1.22.0"

  identifier = "${local.project}-${terraform.workspace}"

  engine                  = "MySQL"
  engine_version          = "5.6.37"
  instance_class          = "db.t2.small"
  allocated_storage       = 8
  port                    = 3306
  storage_encrypted       = true
  backup_retention_period = 30

  name     = "howes_grocery_${terraform.workspace}"
  username = "${var.database_user}"
  password = "${var.database_password}"

  create_db_subnet_group    = false
  create_db_parameter_group = false
  create_db_option_group    = false
  subnet_ids                = ["${module.vpc.database_subnets}"]

  maintenance_window = "Sun:08:00-Sun:11:00"
  backup_window      = "22:00-01:00"

  tags = {
    Name = "${local.project}-${terraform.workspace}"
  }
}
