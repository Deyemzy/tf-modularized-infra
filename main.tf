provider "aws" {
  region = "us-east-1"
}

#VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# Subnet module
module "myapp-subnet" {
  source            = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.myapp-vpc.id

}

module "myapp-webserver" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.myapp-vpc.id
  image_name          = var.image_name
  subnet_id           = module.myapp-subnet.subnet.id
  env_prefix          = var.env_prefix
  public_key_location = var.public_key_location
  avail_zone          = var.avail_zone
  instance_type       = var.instance_type
  my_ip               = var.my_ip
  subnet_cidr_block   = var.subnet_cidr_block

}
