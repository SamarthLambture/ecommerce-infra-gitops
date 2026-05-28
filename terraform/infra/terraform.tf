terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
        }
    }

    backend "s3" {
        bucket = "dev-ecommerce-app-bucket"
        key    = "terraform.tfstate"
        region = "ap-south-2"
        use_lockfile = true
        encrypt      = true
    }
}