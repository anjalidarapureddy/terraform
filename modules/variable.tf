variable "instance_type" {
type = string
description = "instance type of the serer"
}
variable "ami_id"{
type = string
description = "ami for the server"
}
variable "key_name"{
type = string
description = "key file"
}
variable "tag_name" {
type = string
description = "name of the instance"
}
