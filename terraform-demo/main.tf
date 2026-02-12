resource "aws_instance" "terra" {
    instance_type = var.instance_type
    ami = var.ami
    key_name = var.key_name
    subnet_id = aws_subnet.terra_public_s.id
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    tags = {
        Name = var.instance_name
    }
    user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y openjdk-17-jdk
    wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.452.3_all.deb
    sudo dpkg -i jenkins_2.452.3_all.deb
    sudo apt -f install -y
    systemctl enable jenkins
    systemctl start jenkins
    EOF
}

resource "aws_s3_bucket" "terra_remote_bucket"{
    bucket = "anjali-terra-remote-bucket"
    tags = {
        Name = "terra_remote_bucket"
    }
}
resource "aws_s3_bucket_versioning" "versioning"{
    bucket = aws_s3_bucket.terra_remote_bucket.id
    versioning_configuration{
        status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.terra_remote_bucket.id
    rule {
        apply_server_side_encryption_by_default{
            sse_algorithm = "AES256"
        }
    }
}
