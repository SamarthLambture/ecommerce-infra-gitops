resource "aws_key_pair" "my_key" {
    key_name = "${var.env}-${var.key_name}"
    public_key = file("${var.public_key_path}")
    tags = {
        Environment = var.env
    }
}

resource "aws_default_vpc" "default_vpc" {
    # cidr_block = 
}

resource "aws_security_group" "my_sg" {
    name = "${var.env}-security-group"
    description = "Traffic allowance for my EC2 instance" 
    vpc_id = aws_default_vpc.default_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh access"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http access"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "my_instance" {
    for_each = tomap({
        "${var.env}-ecommerce-instance-1" = var.instance_type
    })
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    instance_type = var.instance_type
    ami = var.ami_id
    root_block_device {
        volume_size = var.volume_size
        volume_type = var.volume_type
    }
    tags = {
        Name = each.key
        Environment = var.env
    }
}