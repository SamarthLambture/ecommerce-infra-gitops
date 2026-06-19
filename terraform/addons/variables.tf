variable "region" {
    default = "ap-south-2"
    type = string
}

variable "env" {
    default = "dev"
    description = "Environment name (e.g., dev, staging, prod)"
    type = string
}