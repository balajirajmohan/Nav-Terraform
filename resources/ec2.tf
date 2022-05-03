
# IAM role, Attaching SSM policy and creating EC2 instance

resource "aws_iam_role" "ec2_role" {
    name        = format("%s-%s", var.project_prefix, "ec2-role")
    description = var.ec2_role_description

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

    tags = {
        Name = format("%s-%s", var.project_prefix, "ec2-role")
    }
}

resource "aws_iam_role_policy" "ec2_role_policy" {
    name = format("%s-%s", var.project_prefix, "ec2-role-policy")
    role = aws_iam_role.ec2_role.id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF 
}

resource "aws_iam_role_policy_attachment" "ec2_role_ssm_policy_attach" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = var.ssm_policy_arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = format("%s-%s", var.project_prefix, "ec2-profile")
    role = aws_iam_role.ec2_role.name

    tags = {
        Name = format("%s-%s", var.project_prefix, "ec2-profile")
    }
}


# App EC2 instance creation and configuration

resource "aws_instance" "app_instance" {
    count                  = var.create_app_instance ? 1 : 0
    ami                    = var.ami_app
    instance_type          = var.instance_type_app
    iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
    vpc_security_group_ids = concat(list(aws_security_group.allow_ssh.id), list(aws_security_group.allow_http.id))
    subnet_id              = aws_subnet.public_main.id
    key_name               = var.app_key_name

    volume_tags = {
        Name = "${var.app_volume_name}"
    }

    tags = {
        Name                 = "${var.app_instance_name}"
    }
}

resource "aws_eip" "app_instance_eip" {
    instance = aws_instance.app_instance.*.id
    vpc      = true

    tags = {
        Name = format("%s-%s", var.project_prefix, "app-instance-eip")
    }
}

# Output section for the EC2 and associated resources

output "ec2_role_arn" {
    description = "The ARN of the IAM role for the EC2 instance"
    value       = aws_iam_role.ec2_role.arn
}

output "ec2_role_name" {
    description = "The name of the IAM role for the EC2 instance"
    value       = aws_iam_role.ec2_role.name
}

output "ec2_instance_profile_id" {
    description = "The ID of the instance profile for the EC2 instance"
    value       = aws_iam_instance_profile.ec2_instance_profile.id
}

output "ec2_instance_profile_arn" {
    description = "The ARN of the instance profile for the EC2 instance"
    value       = aws_iam_instance_profile.ec2_instance_profile.arn
}

output "app_server_arn" {
    description = "The ARN of the app server"
    value       = aws_instance.app_instance.*.arn
}

output "app_eip_allocation_id" {
    description = "The EIP allocation Id of the app instance"
    value       = aws_eip.app_instance_eip.allocation_id
}

output "app_eip_public_ip" {
    description = "The EIP of the app instance"
    value       = aws_eip.app_instance_eip.public_ip
}