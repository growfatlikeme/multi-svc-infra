terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4"

    }
  }

  backend "s3" {
    bucket = "sctp-ce10-tfstate"
    key    = "growfat-multiecs-infra.tfstate"
    region = "ap-southeast-1"
  }
}