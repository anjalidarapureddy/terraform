provider "aws" {
region = "ap-south-2"
}

data "aws_key_pair" "existing" {
key_name = "terraform"
}

module "terraform_module_instance" {
# This path points to the folder we created above
source = "./modules"
instance_type = "t3.micro"
ami_id = "ami-02774d409be696d81"
key_name = data.aws_key_pair.existing.key_name
tag_name = "terraform-module"
}
