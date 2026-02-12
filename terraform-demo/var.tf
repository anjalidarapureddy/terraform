variable "aws_region" {
    description = "region for aws"
    type = string
}
variable "instance_type"{
    description = "EC2 instance_type"
    type = string
}
variable "ami" {
    description = "AMI for the EC2"
    type =string
}
variable "key_name"{
    description = "key pair of the ec2 instance"
    type = string
}
variable "instance_name"{
    description = "tag name of the instance"
    type = string
}

variable "cidr_block"{
    description = "ip range"
}
variable "availability_zone"{
    description = "In which zone subnet is created"
    type = string
}
variable "public_subnet_cidr_block"{
    description ="IPv4 cidr block"
}
