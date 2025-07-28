resource "aws_ecr_repository" "s3_service" {
  name         = "growfatlikeme-s3-repo"
  force_delete = true
}

resource "aws_ecr_repository" "service3" {
  name         = "growfatlikeme-sqs-repo"
  force_delete = true
}