module "s3_service_task_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.52.1"

  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  role_requires_mfa = false

  create_role = true
  role_name   = "growfat-s3-service-task-role"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

module "sqs_service_task_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.52.1"

  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  role_requires_mfa = false

  create_role = true
  role_name   = "growfat-sqs-service-task-role"
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}