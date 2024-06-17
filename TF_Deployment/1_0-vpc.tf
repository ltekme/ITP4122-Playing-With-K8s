module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-Service-VPC"

  cidr = "10.0.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
  intra_subnets   = ["10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support = true
}