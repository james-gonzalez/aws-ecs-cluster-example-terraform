terraform {
  backend "s3" {
    bucket = "jamesg-terraform-states"
    key    = "default/ecs-example/terraform.tfstate"
    region = "eu-west-1"
  }
}
