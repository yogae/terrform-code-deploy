variable "subnets" {
  type = list(string)
}

variable "alb_name" {
  type = string
}

variable "vpc_id" {
  description = "The VPC id"
}