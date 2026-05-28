variable "region" {
    default = "ap-south-2"
    type = string
}

variable "env" {
    default = "dev"
    description = "Environment name (e.g., dev, staging, prod)"
    type = string
}

variable "key_name" {
    default = "ecommerce-app-key-pair"
    description = "Name of the AWS key pair"
    type = string
}

variable "public_key_path" {
    default = "~/.ssh/id_ed25519.pub"
    description = "Path to the public key file for the AWS key pair"
    type = string
}

variable "instance_type" {
    default = "t3.micro"
    description = "Type of EC2 instance (e.g., t3.micro)"
    type = string
}

variable "ami_id" {
    default = "ami-024ebedf48d280810"
    description = "AMI ID for the EC2 instance"
    type = string
}

variable "volume_size" {
    default = 11
    description = "Size of the root EBS volume in GB"
    type = number
}

variable "volume_type" {
    default = "gp3"
    description = "Type of the EBS volume (e.g., gp2, io1)"
    type = string
}