module "network" {
  source = "./network"
}

module "instance" {
  source              = "./instances"
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  public_sg_id        = module.network.public_security_group_id
  private_sg_id       = module.network.private_security_group_id
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
}

module "peering" {
  source   = "./vpc_peering"
  vpc_id   = module.network.vpc_id
  vpc_cidr = module.network.vpc_cidr
}