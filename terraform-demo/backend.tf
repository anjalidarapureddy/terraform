terraform{
    backend "s3" {
        bucket = "anjali-terra-remote-bucket"
        key = "terra/terraform.tfstate"
        region = "ap-south-2"
        encrypt = true
    }
}
