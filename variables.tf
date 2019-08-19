variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

# alb
variable "alb_name" {
  type = string
}

# autoscaling
variable "instance_group_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "launch_config_aws_ami" {
  type = string
}
variable "deploy_s3_bucket" {
  type = string
}


# codedeploy
variable "codedeploy_application_name" {
  type = string
}
variable "codedeploy_deployment_group_name" {
  type = string
}


