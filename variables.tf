variable "ecs_cluster_name" {
  type        = "string"
  description = "Default name of the ECS cluster"
  default     = "jamesg-test-cluster"
}

variable "region" {
  description = "region"
  type        = string
  default     = "eu-west-1"
}

variable "s3_bucket_name" {
  default = "jamesg-data-test-bucket"
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "ingress_cidr" {
  type    = list
  default = ["0.0.0.0/0"]
}

variable "egress_cidr" {
  type    = list
  default = ["0.0.0.0/0"]
}
