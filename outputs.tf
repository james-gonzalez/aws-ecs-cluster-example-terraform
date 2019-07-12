output "this_iam_instance_profile_id" {
  value = aws_iam_instance_profile.default.id
}

output "cluster_id" {
  value = aws_ecs_cluster.example.id
}

output "instance_sg_id" {
  value = aws_security_group.allow_ssh.id
}

output "instance_role" {
  value = aws_iam_role.default.name
}

output "ecr_registry_url" {
  value = "${aws_ecr_repository.example.repository_url}"
}
