resource "aws_vpc" "terra_vpc" {
    cidr_block = var.cidr_block
}
resource "aws_internet_gateway" "terra_igw"{
    vpc_id = aws_vpc.terra_vpc.id
    tags = {
        Name = "terra_igw"
    }
}
resource "aws_subnet" "terra_public_s" {
    vpc_id = aws_vpc.terra_vpc.id
    availability_zone = var.availability_zone
    cidr_block = var.public_subnet_cidr_block
    map_public_ip_on_launch = true
    tags = {
        Name = "terra_public_s"
    }
}
resource "aws_route_table" "terra_public_rt"{
    vpc_id = aws_vpc.terra_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terra_igw.id
    }
    tags = {
        Name = "terra_public_rt"
    }
}
resource "aws_route_table_association" "public_rt_association"{
    subnet_id = aws_subnet.terra_public_s.id
    route_table_id = aws_route_table.terra_public_rt.id
}
resource "aws_security_group" "jenkins_sg"{
    name = "jenkins-security-group"
    vpc_id = aws_vpc.terra_vpc.id

    #ssh
    ingress{
        description = "for ssh"
        from_port = 22
        to_port =22
        protocol = "tcp"
        cidr_blocks =["0.0.0.0/0"]
    }
    ingress{
        description = "for jenkins"
        from_port = 8080
        to_port =8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    #outbound required
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags ={
        Name = "jenkins_sg"
    }
}
