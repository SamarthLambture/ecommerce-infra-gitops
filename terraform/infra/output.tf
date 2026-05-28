output "instance_public_ip" {
    value = { for k, v in aws_instance.my_instance : k => v.public_ip }
    description = "Public IP addresses of the EC2 instances"
}

output "instance_private_id" {
    value = { for k, v in aws_instance.my_instance : k => v.private_ip }
    description = "Private IP addresses of the EC2 instances"
}

output "public_dns" {
    value = { for k, v in aws_instance.my_instance : k => v.public_dns }
    description = "Public DNS names of the EC2 instances"
}