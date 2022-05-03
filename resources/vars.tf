
# Varibales declaration for all resources

### Common Variables ###

variable "project_prefix" {
    description = "The prefix of the project"
    type        = string
    default     = "navvis-demo"
}

### VPC variables ###

variable "vpc_cidr" {
    description = "This contains the CIDR block for the main VPC"
    type        = string
    default     = ""
}

variable "vpc_instance_tenancy" {
    description = "This determines the tenancy of the VPC, whether it is a shared VPC or a dedicated one"
    type        = string
    default     = "default"
}

variable "pub_sub_cidr" {
    description = "This contains the CIDR block for the public subnet"
    type        = string
    default     = ""
}

variable "priv_sub_cidr" {
    description = "This contains the CIDR block for the private subnet"
    type        = string
    default     = ""
}

### EC2 SG variables ###

variable "allow_ssh_sg_description" {
    description = "This contains the description of the ssh security group"
    type        = string
    default     = "Allow SSH access from anywhere"
}

variable "allow_ssh_sg_rules" {
    description = "The list of the security group rules for allow_ssh SG"
    type        = list
    default     = []
}

variable "allow_http_sg_description" {
    description = "This contains the description of the http security group"
    type        = string
    default     = "Allow HTTP access from anywhere"
}

variable "allow_http_sg_rules" {
    description = "The list of the security group rules for allow_http SG"
    type        = list
    default     = []
}

### EC2 variables ###

variable "ec2_role_description" {
    description = "The decription of the IAM role"
    type        = string
    default     = "The role that has the necessary permission for the EC2 to perform the operations"
}

variable "ssm_policy_arn" {
    description = "The policy ARN of the SSM"
    type        = string
    default     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "create_app_instance" {
    description = "This determines whether to create the app instance or not"
    type        = bool
    default     = true
}

variable "ami_app" {
    description = "This contains the AMI ID of the app server"
    type        = string
    default     = ""
}

variable "instance_type_app" {
    description = "This contains the instance type for the app server"
    type        = string
    default     = ""
}

variable "app_key_name" {
    description = "The key pair used to connect to the app instance"
    type        = string
    default     = ""
}

variable "app_volume_name" {
    description = "The volume name for the app instance"
    type        = string
    default = ""
}

variable "app_instance_name" {
    description = "The instance name for the app server"
    type        = string
    default = ""
}

### S3 variables ###

variable "force_destroy" {
    description = "This determines whether all the objects inside the bucket need to be deleted, so that the bucket can be destroyed without any error"
    type        = bool
    default     = true
}

### Lambda variables ###

variable "default_lambda_source" {
    description = "This contains the source file for default lambda function"
    type        = string
    default     = "lambda-files/default-lambda.py"
}

variable "default_lambda_package_path" {
    description = "The path in which default lambda zip file will be present in mentioned S3 bucket"
    type        = string
    default     = "lambda-zip-outputs/default_lambda.zip" 
}

variable "non_default_lambda_source" {
    description = "This contains the source file for non-default lambda function"
    type        = string
    default     = "lambda-files/non-default-lambda.py"
}

variable "non_default_lambda_package_path" {
    description = "The path in which non-default lambda zip file will be present in mentioned S3 bucket"
    type        = string
    default     = "lambda-zip-outputs/non_default_lambda.zip"
}

variable "main_lambda_source" {
    description = "This contains the source file for main lambda function"
    type        = string
    default     = "lambda-files/main-lambda.py"
}

variable "main_lambda_package_path" {
    description = "The path in which main lambda zip file will be present in mentioned S3 bucket"
    type        = string
    default     = "lambda-zip-outputs/main_lambda.zip"
}

variable "default_lambda_package_name" {
    description = "The name of the deployment file for default lambda function"
    type        = string
    default     = ""
}

variable "non_default_lambda_package_name" {
    description = "The name of the deployment file for non-default lambda function"
    type        = string
    default     = ""
}

variable "main_lambda_package_name" {
    description = "The name of the deployment file for mains lambda function"
    type        = string
    default     = ""
}

variable "lambda_role_description" {
    description = "The description for the lambda role"
    type        = string
    default     = "The role that contains the necessary policies for the lambda"
}

variable "lambda_role_policy_description" {
    description = "The description for the lambda role policy"
    type        = string
    default     = "The IAM policy which has necessary permission for the lambda function"
}

variable "runtime" {
    description = "The runtime of the lambda function"
    type        = string
    default     = ""
}

variable "memory_size" {
    description = "The amount of memory (in MB) that need to be allocated for the lambda function"
    type        = number
    default     = 1024
}

variable "timeout" {
    description = "The timout period (in seconds) in which the lambda function will not execute"
    type        = number
    default     = 600
}

variable "publish" {
    description = "The determines whether to publish the creation/change as the new lambda function version"
    type        = bool
    default     = true
}


# SNS Subscription Filter policy #

variable "default_subscription_filter_policy" {
    description = This is the filter policy for default jars
    type        = string
    default     = true
}

variable "default_subscription_filter_policy" {
    description = This is the filter policy for non-default jars
    type        = string
    default     = true
}