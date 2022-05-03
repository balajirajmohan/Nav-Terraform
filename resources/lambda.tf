
# Lambda creation and configuration


# Archiving Lambda code to zip file

data "archive_file" "default_lambda" {
    type        = "zip"
    source_file = var.default_lambda_source
    output_path = var.default_lambda_package_path
}

data "archive_file" "non_default_lambda" {
    type        = "zip"
    source_file = var.non_default_lambda_source
    output_path = var.non_default_lambda_package_path
}

data "archive_file" "main_lambda" {
    type        = "zip"
    source_file = var.main_lambda_source
    output_path = var.main_lambda_package_path
}


# Moving zip files to s3 bucket for lambda code deployment

resource "aws_s3_bucket_object" "default_object" {
    bucket = aws_s3_bucket.main_bucket.id
    key    = var.default_lambda_package_name
    source = var.default_lambda_package_path
}

resource "aws_s3_bucket_object" "non_default_object" {
    bucket = aws_s3_bucket.main_bucket.id
    key    = var.non_default_lambda_package_name
    source = var.non_default_lambda_package_path
}

resource "aws_s3_bucket_object" "main_object" {
    bucket = aws_s3_bucket.main_bucket.id
    key    = var.main_lambda_package_name
    source = var.main_lambda_package_path
}


# Default Lambda function and its associated resources

resource "aws_iam_role" "default_lambda_role" {
    name        = format("%s-%s", var.project_prefix, "default-lambda-role")
    description = var.lambda_role_description

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

    tags = {
        Name = format("%s-%s", var.project_prefix, "default-lambda-role")
    }
}

resource "aws_iam_policy" "default_lambda_policy" {
    name        = format("%s-%s", var.project_prefix, "default-lambda-policy")
    description = var.lambda_role_policy_description
    path        = "/"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "s3:PutObject",
              "s3:PutObjectAcl"
            ],

          "Effect": "Allow",
          "Resource": [
              "${aws_s3_bucket.main_bucket.arn}",
              "${aws_s3_bucket.main_bucket.arn}/*"
          ]    
      },
      {
          "Action": [
              "sns:Publish"
            ],

          "Effect": "Allow",
          "Resource": [
              "${aws_sns_topic.main_topic.arn}"
          ]    
      },
      {
          "Action": [
              "ssm:*",
              "ec2:*"
            ],

          "Effect": "Allow",
          "Resource": "*"  
      },
      {
          "Action": [
              "logs:CreateLogGroup"
            ],

          "Effect": "Allow",
          "Resource": [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          ]
      },
      {
          "Action": [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],

          "Effect": "Allow",
          "Resource": [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_prefix}-default-lambda-function:*"
          ]
      }
    ]
}
EOF

    tags = {
        Name = format("%s-%s", var.project_prefix, "default-lambda-policy")
    }
}

resource "aws_iam_role_policy_attachment" "default_lambda_role_attachment" {
    role       = aws_iam_role.default_lambda_role.name
    policy_arn = aws_iam_policy.default_lambda_policy.arn
}

resource "aws_lambda_function" "default_lambda_function" {
    function_name    = format("%s-%s", var.project_prefix, "default-lambda-function")
    role             = aws_iam_role.default_lambda_role.arn
    description      = "This contains the code for the default lambda function"
    handler          = "default-lambda.lambda_handler"
    runtime          = var.runtime
    memory_size      = var.memory_size
    timeout          = var.timeout
    publish          = var.publish
    s3_bucket        = aws_s3_bucket.main_bucket.id
    s3_key           = var.default_lambda_package_name
}

resource "aws_lambda_permission" "default_lambda_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default_lambda_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.main_topic.arn
}


# Non-Default Lambda function and its associated resources

resource "aws_iam_role" "non_default_lambda_role" {
    name        = format("%s-%s", var.project_prefix, "non-default-lambda-role")
    description = var.lambda_role_description

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

    tags = {
        Name = format("%s-%s", var.project_prefix, "non-default-lambda-role")
    }
}

resource "aws_iam_policy" "non_default_lambda_policy" {
    name        = format("%s-%s", var.project_prefix, "non-default-lambda-policy")
    description = var.lambda_role_policy_description
    path        = "/"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "s3:PutObject",
              "s3:PutObjectAcl"
            ],

          "Effect": "Allow",
          "Resource": [
              "${aws_s3_bucket.main_bucket.arn}",
              "${aws_s3_bucket.main_bucket.arn}/*"
          ]    
      },
      {
          "Action": [
              "sns:Publish"
            ],

          "Effect": "Allow",
          "Resource": [
              "${aws_sns_topic.main_topic.arn}"
          ]    
      },
      {
          "Action": [
              "ssm:*",
              "ec2:*"
            ],

          "Effect": "Allow",
          "Resource": "*"
      },
      {
          "Action": [
              "logs:CreateLogGroup"
            ],

          "Effect": "Allow",
          "Resource": [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          ]
      },
      {
          "Action": [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],

          "Effect": "Allow",
          "Resource": [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_prefix}-non-default-lambda-function:*"
          ]
      }
    ]
}
EOF

    tags = {
        Name = format("%s-%s", var.project_prefix, "non-default-lambda-policy")
    }
}

resource "aws_iam_role_policy_attachment" "non_default_lambda_role_attachment" {
    role       = aws_iam_role.non_default_lambda_role.name
    policy_arn = aws_iam_policy.non_default_lambda_policy.arn
}

resource "aws_lambda_function" "non_default_lambda_function" {
    function_name    = format("%s-%s", var.project_prefix, "non-default-lambda-function")
    role             = aws_iam_role.non_default_lambda_role.arn
    description      = "This contains the code for the non-default lambda function"
    handler          = "non-default-lambda.lambda_handler"
    runtime          = var.runtime
    memory_size      = var.memory_size
    timeout          = var.timeout
    publish          = var.publish
    s3_bucket        = aws_s3_bucket.main_bucket.id
    s3_key           = var.non_default_lambda_package_name
}

resource "aws_lambda_permission" "non_default_lambda_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.non_default_lambda_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.main_topic.arn
}


# Main Lambda function and its associated resources

resource "aws_iam_role" "main_lambda_role" {
    name        = format("%s-%s", var.project_prefix, "main-lambda-role")
    description = var.lambda_role_description

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

    tags = {
        Name = format("%s-%s", var.project_prefix, "main-lambda-role")
    }
}

resource "aws_iam_policy" "main_lambda_policy" {
    name        = format("%s-%s", var.project_prefix, "main-lambda-policy")
    description = var.lambda_role_policy_description
    path        = "/"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "s3:PutObject",
              "s3:PutObjectAcl"
            ],

          "Effect": "Allow",
          "Resource": [
              "${aws_s3_bucket.main_bucket.arn}",
              "${aws_s3_bucket.main_bucket.arn}/*"
          ]    
      },
      {
          "Action": [
              "sns:Publish"
            ],

          "Effect": "Allow",
          "Resource": [
              "${aws_sns_topic.main_topic.arn}"
          ]    
      },
      {
          "Action": [
              "ssm:*",
              "ec2:*"
            ],

          "Effect": "Allow",
          "Resource": "*"
      },
      {
          "Action": [
              "logs:CreateLogGroup"
            ],

          "Effect": "Allow",
          "Resource": [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          ]
      },
      {
          "Action": [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],

          "Effect": "Allow",
          "Resource": [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_prefix}-main-lambda-function:*"
          ]
      }
    ]
}
EOF

    tags = {
        Name = format("%s-%s", var.project_prefix, "main-lambda-policy")
    }
}

resource "aws_iam_role_policy_attachment" "main_lambda_role_attachment" {
    role       = aws_iam_role.main_lambda_role.name
    policy_arn = aws_iam_policy.main_lambda_policy.arn
}

resource "aws_lambda_function" "main_lambda_function" {
    function_name    = format("%s-%s", var.project_prefix, "main-lambda-function")
    role             = aws_iam_role.main_lambda_role.arn
    description      = "This contains the code for the main lambda function"
    handler          = "main-lambda.lambda_handler"
    runtime          = var.runtime
    memory_size      = var.memory_size
    timeout          = var.timeout
    publish          = var.publish
    s3_bucket        = aws_s3_bucket.main_bucket.id
    s3_key           = var.main_lambda_package_name
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main_lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.main_bucket.arn
}


# Output section for lambda and its associated resources

output "default_lambda_role_arn" {
    description = "The ARN of the IAM role for default lambda function"
    value       = aws_iam_role.default_lambda_role.arn
}

output "default_lambda_role_name" {
    description = "The name of the IAM role for default lambda function"
    value       = aws_iam_role.default_lambda_role.name
}

output "non_default_lambda_role_arn" {
    description = "The ARN of the IAM role for non default lambda function"
    value       = aws_iam_role.non_default_lambda_role.arn
}

output "non_default_lambda_role_name" {
    description = "The name of the IAM role for non default lambda function"
    value       = aws_iam_role.non_default_lambda_role.name
}

output "main_lambda_role_arn" {
    description = "The ARN of the IAM role for main lambda function"
    value       = aws_iam_role.main_lambda_role.arn
}

output "main_lambda_role_name" {
    description = "The name of the IAM role for main lambda function"
    value       = aws_iam_role.main_lambda_role.name
}

output "default_lambda_function_arn" {
    description = "The ARN of the default lambda function"
    value       = aws_lambda_function.default_lambda_function.arn
}

output "non_default_lambda_function_arn" {
    description = "The ARN of the non-default lambda function"
    value       = aws_lambda_function.non_default_lambda_function.arn
}

output "main_lambda_function_arn" {
    description = "The ARN of the main lambda function"
    value       = aws_lambda_function.main_lambda_function.arn
}

output "default_lambda_function_name" {
    description = "The name of the default lambda function"
    value       = aws_lambda_function.default_lambda_function.function_name
}

output "non_default_lambda_function_name" {
    description = "The name of the non-default lambda function"
    value       = aws_lambda_function.non_default_lambda_function.function_name
}

output "main_lambda_function_name" {
    description = "The name of the main lambda function"
    value       = aws_lambda_function.main_lambda_function.function_name
}