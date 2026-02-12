terraform{
    backend "s3" {
        bucket = "anjali_terra_remote_bucket"
        key = "terra/terraform.tfstate"
        region = "ap-south-2"
        encrypt = true
    }
}
