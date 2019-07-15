provider "aws" {
  region = var.region
}

provider "template" {}

resource "aws_ecs_cluster" "example" {
  name = var.ecs_cluster_name
}

resource "aws_s3_bucket" "data" {
  bucket = var.s3_bucket_name
  acl    = "private"
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "example-repo-s3-put"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "example" {
  family = "example"

  container_definitions = <<EOF
[
  {
    "name": "example-repo-s3-put",
    "image": "${aws_ecr_repository.example.repository_url}:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "example-repo-s3-put",
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

####  ASG for ECS Optimised Instances ####
data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.sh")}"

  vars = {
    additional_user_data_script = var.additional_user_data_script
    ecs_cluster = aws_ecs_cluster.example.name
    log_group = aws_cloudwatch_log_group.example.name
  }
}

resource "aws_launch_configuration" "instance" {
  name_prefix = "example-ecs-lc"
  image_id = data.aws_ami.ecs.id
  instance_type = "t2.small"
  iam_instance_profile = aws_iam_instance_profile.default.name
  user_data = data.template_file.user_data.rendered
  security_groups = [aws_security_group.allow_ssh.id]
  key_name = aws_key_pair.default.key_name

  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "example-ecs-asg"

  launch_configuration = "${aws_launch_configuration.instance.name}"
  vpc_zone_identifier = module.vpc.private_subnets
  max_size = "1"
  min_size = "1"
  desired_capacity = "1"

  health_check_grace_period = 300
  health_check_type = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "example" {
  name = "example-repo-s3-put"
}
