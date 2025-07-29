module "s3_service_task_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  role_requires_mfa = false

  create_role = true
  role_name   = "growfat-s3-service-task-role"
  custom_role_policy_arns = [
    module.iam_policy.arn
  ]
}

module "sqs_service_task_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  role_requires_mfa = false

  create_role = true
  role_name   = "growfat-sqs-service-task-role"
  custom_role_policy_arns = [
    module.sqs_iam_policy.arn
  ]
}
module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"

  name = "growfat-s3-bucket-access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.s3_service_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "${aws_s3_bucket.s3_service_bucket.arn}"
    }
  ]
}
EOF
}
module "sqs_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"

  name = "growfat-sqs-queue-access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:GetQueueAttributes"
      ],
      "Resource": "${aws_sqs_queue.sqs_service_queue.arn}"
    }
  ]
}
EOF
}