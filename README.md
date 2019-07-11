# AWS EC2 Instance Terraform 

This is an example bit of code written in Terraform at version `0.12.3`. This shows you the fundamentals of Terraform and some cool little utilities you can use to maximise your development process and ensure maximum code quality in an automated fashion.

## Features
* EC2 Instance
* Automated Semantic Versioning/Tagging and updating of CHANGELOG.md
* Creation of an S3 bucket for data storage
* Attachment of an IAM policy to acccess that bucket


## Requirements
* [git-chglog](https://github.com/git-chglog/git-chglog)
* [semtag](https://github.com/pnikosis/semtag)

Terraform module which creates EC2 instance(s) on AWS.

These types of resources are supported:

* [EC2 instance](https://www.terraform.io/docs/providers/aws/r/instance.html)


## Usage
```bash
terraform init
terraform plan
terraform apply
```


## Notes


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_user\_data\_script | extra stuff you want to put into your user-data.sh scripts | string | `"echo example ecs cluster being provisioned"` | no |
| ecs\_cluster\_name | Default name of the ECS cluster | string | `"jamesg-test-cluster"` | no |
| egress\_cidr |  | list | `[ "0.0.0.0/0" ]` | no |
| ingress\_cidr |  | list | `[ "0.0.0.0/0" ]` | no |
| region | region | string | `"eu-west-1"` | no |
| s3\_bucket\_name |  | string | `"jamesg-data-test-bucket"` | no |
| vpc\_cidr |  | string | `"10.1.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id |  |
| instance\_role |  |
| instance\_sg\_id |  |
| this\_iam\_instance\_profile\_id |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Code written by [James Gonzalez](https://github.com/cultavix)
