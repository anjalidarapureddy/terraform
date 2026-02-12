# terraform
''' install terraform by executing this commands:
sudo apt update 
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/

check the version:sudo mv terraform /usr/local/bin/

mkdir terraform-demo
cd terraform-demo
 and aslo install aws-cli to interact with aws
 curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
verify the file size: ls -lh awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install
aws --version

After AWS CLI works: aws configure
secret-key, access-key, region

 write the .tf files for creating ec2 instance
 create .pem file using cli by using the command like
  aws ec2 create-key-pair \
  --key-name terra-key \
  --region ap-south-2 \
  --query KeyMaterial \
  --output text > terra-key.pem

  to check the existing keypairs in aws: aws ec2 describe-key-pairs --region ap-south-2
# expected error at creating instance - pem file doesn't exist but it is in local directory . it is not properly created inside the aws then recreate it 
to delete the keypair:
  aws ec2 delete-key-pair \
  --key-name terraform-key \
  --region ap-south-2

# terraform.tfstate.backup?
A backup copy of the previous state file. Terraform automatically creates it when state changes.


# terraform backend
Terraform backend cannot depend on resources created in the same configuration.
So process is:
1️⃣ First create S3 bucket
2️⃣ Then configure backend means enable versioning, encryption
3️⃣ Then run terraform init and apply
then add backend.tf then Reinitialize Terraform, Now your state is stored in S3.

# terraform provisioners
Provisioners in Terraform are post-creation execution mechanisms used to run scripts or commands on a resource after it is created (or before it is destroyed).A provisioner allows you to execute:
Local commands, Remote commands, File transfers. After a resource is created.
1️⃣local-exec
Runs a command on your local machine (where Terraform is running).
Example:
resource "aws_instance" "dev" {
  ami           = var.ami
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ips.txt"
  }
}
📌 This runs on your laptop / CI server.
2️⃣ remote-exec
Runs commands inside the created resource (like SSH into EC2).
Example:
resource "aws_instance" "dev" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = var.key_name

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("mykey.pem")
      host        = self.public_ip
    }
  }
}
📌 Terraform SSHs into EC2 and installs nginx.
3️⃣ file
Copies files from local → remote machine.
provisioner "file" {
  source      = "app.conf"
  destination = "/home/ubuntu/app.conf"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("mykey.pem")
    host        = self.public_ip
  }
}
Terraform cannot properly track what provisioners change.
If provisioning fails:
Resource may already be created
State may become inconsistent. 
Instead of remote-exec, use:
✔️ user_data in EC2 bcz Multi-line Commands Inside inline in provisioners — Risky
