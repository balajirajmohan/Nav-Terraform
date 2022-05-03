
# VPC resource creation and configuration

resource "aws_vpc" "main" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = var.vpc_instance_tenancy

    tags = {
        Name = format("%s-%s", var.project_prefix, "main")
    }
}

resource "aws_subnet" "public_main" {
    vpc_id     = aws_vpc.main.id
    cidr_block = var.pub_sub_cidr

    tags = {
        Name = format("%-%s", var.project_prefix, "public-main")
    }
}

resource "aws_subnet" "private_main" {
    vpc_id     = aws_vpc.main.id
    cidr_block = var.priv_sub_cidr

    tags = {
        Name = format("%s-%s", var.project_prefix, "private-main")
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = format("%s-%s", var.project_prefix, "main-igw")
    }
}

resource "aws_route_table" "public_main_rt" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = format("%s-%s", var.project_prefix, "public-main-rt")
    }
}

resource "aws_route_table" "private_main_rt" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = format("%s-%s", var.project_prefix, "private-main-rt")
    }
}

resource "aws_route" "pub_main_route" {
    route_table_id         = aws_route_table.public_main_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main.id
    depends_on             = [aws_route_table.public_main_rt.id]
}

resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id      = aws_subnet.public_main.id
    route_table_id = aws_route_table.public_main_rt.id
}

resource "aws_route_table_association" "private_rt_assoc" {
    subnet_id      = aws_subnet.private_main.id
    route_table_id = aws_route_table.private_main_rt.id
}


# Output section for the VPC and associated resources

 output "vpc_id" {
    description = "The ID of the main VPC"
    value       = aws_vpc.main.id
}

 output "vpc_arn" {
    description = "The ARN of the main VPC"
    value       = aws_vpc.main.arn
}

 output "vpc_cidr" {
    description = "The CIDR block of the main VPC"
    value       = aws_vpc.main.cidr_block
}

output "vpc_default_security_group_id" {
    description = "The Default security group ID of the main VPC"
    value       = aws_vpc.main.default_security_group_id
}

output "pub_sub_id" {
    description = "The ID of the main public subnet"
    value       = aws_subnet.public_main.id
}

output "pub_sub_arn" {
    description = "The ARN of the main public subnet"
    value       = aws_subnet.public_main.arn
}

output "priv_sub_id" {
    description = "The ID of the main private subnet"
    value       = aws_subnet.private_main.id
}

output "priv_sub_arn" {
    description = "The ARN of the main private subnet"
    value       = aws_subnet.private_main.arn
}

output "pub_rt_id" {
    description = "The ID of the public main route table"
    value       = aws_route_table.public_main_rt.id
}

output "pub_rt_arn" {
    description = "The ARN of the public main route table"
    value       = aws_route_table.public_main_rt.arn
}

output "priv_rt_id" {
    description = "The ID of the private main route table"
    value       = aws_route_table.private_main_rt.id
}

output "priv_rt_arn" {
    description = "The ARN of the private main route table"
    value       = aws_route_table.private_main_rt.arn
}