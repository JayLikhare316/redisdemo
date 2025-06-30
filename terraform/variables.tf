variable "ami_id" {
  description = "The ID of the AMI to use for the instances."
  type        = string
  default     = "ami-09b0a86a2c84101e1"
}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the instances."
  type        = string
  default     = "my-key-aws"
}
