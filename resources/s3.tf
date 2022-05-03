
# S3 bucket creation and associated resources

resource "aws_s3_bucket" "main_bucket" {
    bucket        = format("%s-%s", var.project_prefix, "main-bucket")
    force_destroy = var.force_destroy

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    tags = {
      Name = format("%s-%s", var.project_prefix, "main-bucket")
  }
}

resource "aws_s3_bucket_policy" "bp_main" {
    bucket = aws_s3_bucket.main_bucket.id
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "S3PolicyId1",
    "Statement": [
        {
            "Sid": "Stmt1597417032804",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.ec2_role.arn}"
                ]
            },
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl"
            ],
            "Resource": [
                "${aws_s3_bucket.main_bucket.arn}/*",
                "${aws_s3_bucket.main_bucket.arn}"
            ]
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = aws_s3_bucket.main_bucket.id

    lambda_function {
      lambda_function_arn = aws_lambda_function.main_lambda_function.arn
      events = ["s3:ObjectCreated:*"]
    }

    depends_on = [aws_lambda_permission.allow_bucket]
}


# Output section for S3 and associated resources

output "s3_main_bucket_id" {
    description = "The bucket name for the main bucket"
    value       = aws_s3_bucket.main_bucket.id
}

output "s3_main_bucket_arn" {
    description = "The ARN of the main bucket"
    value       = aws_s3_bucket.main_bucket.arn
}