resource "aws_s3_bucket" "my-bucket" {
  bucket = "${var.env}-ecommerce-app-bucket"

  tags = {
    Name        = "${var.env}-ecommerce-app-bucket"
    Environment = var.env
  }
}