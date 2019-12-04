provider "aws" {
  region = var.aws_region
}

# create new sqs queue
resource "aws_sqs_queue" "go-sqs-queue" {
  name                      = var.aws_sqs_queue_name
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
}

# create new iam policy to use sqs queue
resource "aws_iam_policy" "go-sqs-queue-policy" {
  name = "sqs-${var.aws_sqs_queue_name}-policy"
  policy = data.aws_iam_policy_document.go-sqs-queue-policy-doc.json
}

# policy data
data "aws_iam_policy_document" "go-sqs-queue-policy-doc" {
  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:ChangeMessageVisibility",
      "sqs:SendMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:DeleteMessageBatch",
      "sqs:PurgeQueue",
      "sqs:DeleteQueue",
      "sqs:CreateQueue",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:SetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.go-sqs-queue.arn
    ]
  }
}

# create new iam user to use sqs queue
resource "aws_iam_user" "go-sqs-iam-user" {
  name = var.aws_iam_user
}

# create new iam access key for that user
resource "aws_iam_access_key" "go-sqs-iam-user" {
  user = aws_iam_user.go-sqs-iam-user.name
}

# output secret to store it in aws-vault
output "secret" {
  value = "${aws_iam_access_key.go-sqs-iam-user.secret}"
}

# connect user with policy for access rights (!Achtung!)
resource "aws_iam_user_policy_attachment" "go-sqs-iam-user-attachment" {
  user = aws_iam_user.go-sqs-iam-user.name
  policy_arn = aws_iam_policy.go-sqs-queue-policy.arn
}

# create iam role
resource "aws_iam_role" "go-sqs-iam-role" {
  name = "go-graphql-sqs-example-role"
  assume_role_policy = data.aws_iam_policy_document.go-sqs-iam-role-policy.json
}

# role data (relationship between sqs user and role)
data "aws_iam_policy_document" "go-sqs-iam-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.go-sqs-iam-user.arn]
    }
  }
}

# connect role with policy
resource "aws_iam_role_policy_attachment" "go-sqs-iam-role-attach" {
  role = aws_iam_role.go-sqs-iam-role.name
  policy_arn = aws_iam_policy.go-sqs-queue-policy.arn
}
