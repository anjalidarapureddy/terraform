resource "aws_instance" "module"{
instance_type = var.instance_type
ami = var.ami_id
key_name = var.key_name
tags = {
 Name = var.tag_name
}
}
