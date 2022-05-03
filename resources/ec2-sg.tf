
# SG creation and configuration for EC2 instances

resource "aws_security_group" "allow_ssh" {
    name        = format("%s-%s", var.project_prefix, "ssh")
    description = var.allow_ssh_sg_description
    vpc_id      = aws_vpc.main.id

    tags = {
        Name = format("%s-%s", var.project_prefix, "ssh")
    }
}

resource "aws_security_group_rule" "allow_ssh_sg_rule" {
    count             = length(var.allow_ssh_sg_rules)
    security_group_id = aws_security_group.allow_ssh.id
    type              = lookup(var.allow_ssh_sg_rules[count.index], "type")
    description       = lookup(var.allow_ssh_sg_rules[count.index], "description")
    from_port         = lookup(var.allow_ssh_sg_rules[count.index], "from_port")
    to_port           = lookup(var.allow_ssh_sg_rules[count.index], "to_port")
    protocol          = lookup(var.allow_ssh_sg_rules[count.index], "protocol")
    cidr_blocks       = split(",", lookup(var.allow_ssh_sg_rules[count.index], "cidr_blocks"))
}

resource "aws_security_group" "allow_http" {
    name        = format("%s-%s", var.project_prefix, "http")
    description = var.allow_http_sg_description
    vpc_id      = aws_vpc.main.id

    tags = {
        Name = format("%s-%s", var.project_prefix, "http")
    }
}

resource "aws_security_group_rule" "allow_http_sg_rule" {
    count             = length(var.allow_http_sg_rules)
    security_group_id = aws_security_group.allow_http.id
    type              = lookup(var.allow_http_sg_rules[count.index], "type")
    description       = lookup(var.allow_http_sg_rules[count.index], "description")
    from_port         = lookup(var.allow_http_sg_rules[count.index], "from_port")
    to_port           = lookup(var.allow_http_sg_rules[count.index], "to_port")
    protocol          = lookup(var.allow_http_sg_rules[count.index], "protocol")
    cidr_blocks       = split(",", lookup(var.allow_http_sg_rules[count.index], "cidr_blocks"))
}


# Output section for the Security group and associated resources

output "allow_ssh_sg_id" {
    description = "The SG id for the allow_ssh security group"
    value       = aws_security_group.allow_ssh.id 
}

output "allow_ssh_sg_arn" {
    description = "The SG ARN for the allow_ssh security group"
    value       = aws_security_group.allow_ssh.arn
}

output "allow_http_sg_id" {
    description = "The SG id for the allow_http security group"
    value       = aws_security_group.allow_http.id
}

output "allow_http_sg_arn" {
    description = "The SG ARN for the allow_http security group"
    value       = aws_security_group.allow_http.arn
}