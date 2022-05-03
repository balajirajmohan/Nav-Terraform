
# TFVARS declaration


# Lambda related vars
runtime                         = "python3.8"
memory_size                     = 1024
timeout                         = 600
default_lambda_package_name     = "default_lambda.zip" 
non_default_lambda_package_name = "non_default_lambda.zip"
main_lambda_package_name        = "main_lambda.zip"


# VPC related vars
vpc_cidr                   = "10.0.0.0/16"
priv_sub_cidr              = "10.0.1.0/24"
transit_gateway_id         = "10.0.2.0/24"


# EC2 SG related vars
allow_ssh_sg_rules = [
    {
        "type"        = "ingress"
        "description" = "Allow SSH access from anywhere"
        "from_port"   = "22"
        "to_port"     = "22"
        "protocol"    = "TCP"
        "cidr_blocks" = ""
    },

    {
        "type"        = "egress"
        "description" = "Egress rule for SG"
        "from_port"   = "0"
        "to_port"     = "0"
        "protocol"    = "-1"
        "cidr_blocks" = ""
    }
]

allow_http_sg_rules = [
    {
        "type"        = "ingress"
        "description" = "Allow HTTP access from anywhere"
        "from_port"   = "8080"
        "to_port"     = "8080"
        "protocol"    = "TCP"
        "cidr_blocks" = ""
    },

    {
        "type"        = "egress"
        "description" = "Egress rule for SG"
        "from_port"   = "0"
        "to_port"     = "0"
        "protocol"    = "-1"
        "cidr_blocks" = ""
    }
]


# EC2 related vars
create_app_instance = true
ami_app             = ""
instance_type_app   = ""
app_key_name        = ""
app_volume_name     = ""
app_instance_name   = ""

# Subscription Filter policy

main_topic_default_subscription = [
    {
        "message" : [It's a default Jar]
    }
]

main_topic_non_default_subscription = [
    {
        "message" : [It's a non-default Jar]
    }
]


