provider "aws" {
  region = var.region
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
    "name": "example",
    "image": "hello-world",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "eu-west-1",
        "awslogs-group": "hello_world",
        "awslogs-stream-prefix": "example"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "example" {
  name = "hello_world"
  cluster = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.example.arn

  desired_count = 1

  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0
}