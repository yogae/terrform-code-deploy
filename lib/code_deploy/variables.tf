variable "application_name" {
  type = string
}

variable "deployment_group_name" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

variable "alb_target_group_name" {
  type = string
}

variable "autoscaling_groups" {
  type = list(string)
}
