variable "ec2_instance_type" {
  description = "Type of AWS instance"
  default     = "t2.micro"
}

variable "ec2_default_root_storage_size" {
  description = "Size of the root storage"
  default     = 8
  type        = number
}

variable "ec2_ami_id"{
    default = "ami-01a00762f46d584a1"
    type = string
}

variable "env"{
  default = "prod"
  type = string
}