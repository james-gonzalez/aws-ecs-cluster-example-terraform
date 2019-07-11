provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "example"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "example" {
  family = "example"

  container_definitions = <<EOF
[
  {
    "name": "nginx",
    "image": "nginx:1.13-alpine",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "example-app-nginx",
        "awslogs-region": "eu-west-1"
      }
    },
    "memory": 128,
    "cpu": 100
  }
]
EOF
}

resource "aws_ecs_service" "example" {
  name = "example"
  cluster = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.example.arn
  desired_count = "2"
  # iam_role        = aws_iam_role.default.arn
}
