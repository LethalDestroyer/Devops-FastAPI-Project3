module "vpc" {
  source = "./vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zone = var.availability_zone
  project = var.project
}

module "ec2" {
  source         = "./ec2"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnet_ids
  ami_id         = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type  = "t2.micro"
  docker_image   = "devopsdestroyer/fastapi-devops-app:v1.0.2"
  project        = var.project
}
