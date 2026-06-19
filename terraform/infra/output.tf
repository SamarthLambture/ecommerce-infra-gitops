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

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}