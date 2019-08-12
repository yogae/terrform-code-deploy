variable "subnets" {
  type = list(string)
}

variable "instance_group_name" {
  type = string
}

variable "aws_ami" {
  type = string
  default = "ami-095ca789e0549777d"
}

variable "instance_type" {
  type = string
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "key_name" {
  type = string
}

variable "max_size" {
  
}

variable "min_size" {
  
}

variable "desired_capacity" {
  
}

variable "code_deploy_resource_kit_bucket" {
  type = string
  default = "aws-codedeploy-ap-northeast-2"
}

variable "code_deploy_resource_kit_region" {
  type = string
  default = "ap-northeast-2"
}

variable "alb_target_group_arn" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "deploy_s3_bucket" {
  type = string
}
