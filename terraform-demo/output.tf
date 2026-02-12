output "instance_id"{
    value = aws_instance.terra.id
}
output "public_ip"{
    value = aws_instance.terra.public_ip
}
output "vpc_id" {
    value = aws_vpc.terra_vpc.id
}
output "subnet_id"{
    value = aws_subnet.terra_public_s.id
}
