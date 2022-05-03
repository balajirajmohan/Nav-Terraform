
# SNS topic creation and configuration

resource "aws_sns_topic" "main_topic" {
    name = format("%s-%s", var.project_prefix, "main-topic")

    tags = {
        Name = format("%s-%s", var.project_prefix, "main-topic")
    }
}

resource "aws_sns_topic_policy" "main_topic_policy" {
    arn    = aws_sns_topic.main_topic.arn
    policy = data.aws_iam_policy_document.main_topic_policy.json
}

data "aws_iam_policy_document" "main_topic_policy" {
    policy_id = "__default_policy_ID"

    statement {
        actions = [
            "SNS:Publish"
        ]

        effect = "Allow"

        principals {
            type        = "AWS"
            identifiers = ["*"]
        }

        resources = [
            aws_sns_topic.process_updates_topic.arn
        ]

        sid = "__default_statement_ID"
    }
}

resource "aws_sns_topic_subscription" "main_topic_default_subscription" {
    topic_arn     = aws_sns_topic.main_topic.arn
    protocol      = "lambda"
    endpoint      = aws_lambda_function.default_lambda_function.arn
    filter_policy = var.default_subscription_filter_policy
}

resource "aws_sns_topic_subscription" "main_topic_non_default_subscription" {
    topic_arn     = aws_sns_topic.main_topic.arn
    protocol      = "lambda"
    endpoint      = aws_lambda_function.non_default_lambda_function.arn
    filter_policy = var.non_default_subscription_filter_policy
}


# Output section for SNS and its associated resources

output "sns_topic_arn" {
    description = "The ARN of the main SNS topic"
    value       = aws_sns_topic.main_topic.arn
}

output "default_subscription_arn" {
    description = "The ARN of the default lambda function subscription"
    value       = aws_sns_topic_subscription.main_topic_default_subscription.arn
}

output "non_default_subscription_arn" {
    description = "The ARN of the non-default lambda function subscription"
    value       = aws_sns_topic_subscription.main_topic_non_default_subscription.arn
}