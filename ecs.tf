resource "aws_s3_bucket" "s3_service_bucket" {
  bucket = "growfatlikeme-s3-bucket"
}

resource "aws_sqs_queue" "sqs_service_queue" {
  name = "growfatlikeme-sqs-service-queue"
}


module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.1.0"

  cluster_name = "${local.name_prefix}-multi-ecs-new"

  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 100
    }
  }

  services = {
    growfat-s3-service = {
      cpu    = 512
      memory = 1024

      container_definitions = {
        growfat-s3-container = {
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com/growfatlikeme-s3-repo:latest"

          portMappings = [
            {
              name          = "growfat-s3-port"
              containerPort = 5001
              protocol      = "tcp"
            }
          ]
          environment = [
            {
              name  = "AWS_REGION"
              value = "ap-southeast-1"
            },
            {
              name  = "BUCKET_NAME"
              value = "growfatlikeme-s3-bucket"
            }
          ]

        }
      }

      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                         = module.vpc.public_subnets
      security_group_ids                 = [module.s3_service_sg.security_group_id]
      create_security_group              = false
      create_task_exec_iam_role          = false
      task_exec_iam_role_arn             = module.s3_service_task_role.iam_role_arn
      task_iam_role_arn                  = module.s3_service_task_role.iam_role_arn

    }

    growfat-sqs-service = {
      cpu    = 512
      memory = 1024
      container_definitions = {
        growfat-sqs-service-container = {
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com/growfatlikeme-sqs-service-ecr:latest"
          portMappings = [
            {
              containerPort = 5002
              protocol      = "tcp"
            }
          ]
          environment = [
            {
              name  = "AWS_REGION"
              value = "ap-southeast-1"
            },
            {
              name  = "QUEUE_URL"
              value = "growfatlikeme-sqs-service-queue"
            }
          ]
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                         = module.vpc.public_subnets
      security_group_ids                 = [module.sqs_service_sg.security_group_id]
      create_security_group              = false
      create_task_exec_iam_role          = false
      task_exec_iam_role_arn             = module.sqs_service_task_role.iam_role_arn
      task_iam_role_arn                  = module.sqs_service_task_role.iam_role_arn
    }
  }
}