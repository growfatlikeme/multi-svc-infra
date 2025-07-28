variable "name" {
  type        = string
  description = "Ownership of resources"
  default     = "growfatlikeme"
}

variable "environment" {
  type        = string
  description = "Environment type (dev, staging, prod)"
  default     = "ecs-dev-new"
}
variable "azs" {
  type        = list(string)
  description = "Availability zones"
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}