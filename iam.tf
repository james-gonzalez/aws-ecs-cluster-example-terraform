resource "aws_iam_role" "default" {
  name               = "ecs_role"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_instance_profile" "default" {
  name = "ecs_instance_profile"
  role = aws_iam_role.default.name
}

resource "aws_iam_role_policy" "default" {
  name   = "ecs-default-policy"
  role   = aws_iam_role.default.name
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "s3.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Put*",
      "s3:Get*"
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
