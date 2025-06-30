variable "public_instance_count" {
  description = "The number of public instances to create."
  type        = number
  default     = 1
}

variable "private_instance_count" {
  description = "The number of private instances to create."
  type        = number
  default     = 3
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instances."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the instances."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of IDs for the public subnets."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of IDs for the private subnets."
  type        = list(string)
}

variable "public_sg_id" {
  description = "The ID of the public security group."
  type        = string
}

variable "private_sg_id" {
  description = "The ID of the private security group."
  type        = string
}
