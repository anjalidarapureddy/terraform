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
    apt update -y
    apt install -y openjdk-17-jdk
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    apt update -y
    apt install -y jenkins
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
