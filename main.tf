module "alb" {
  source = "./lib/alb"

  subnets             = "${var.subnets}"
  alb_name            = "${var.alb_name}"
  vpc_id              = "${var.vpc_id}"
}

module "autoscaling" {
  source = "./lib/autoscaling"

  subnets               = "${var.subnets}"
  instance_group_name   = "${var.instance_group_name}"
  instance_type         = "${var.instance_type}"
  vpc_id                = "${var.vpc_id}"
  key_name              = "${var.key_name}"
  aws_ami               = "${var.launch_config_aws_ami}"
  deploy_s3_bucket      = "${var.deploy_s3_bucket}"
  max_size              = 2
  min_size              = 1
  desired_capacity      = 1

  alb_target_group_arn  = "${module.alb.target_group_arn}"
  alb_security_group_id = "${module.alb.security_group_id}"
}
module "code_deploy" {
  source = "./lib/code_deploy"
  
  application_name      = "${var.codedeploy_application_name}"
  deployment_group_name = "${var.codedeploy_deployment_group_name}"

  alb_listener_arn      = "${module.alb.listener_arn}"
  alb_target_group_name = "${module.alb.target_group_name}"
  autoscaling_groups   = ["${module.autoscaling.aws_autoscaling_group_name}"]
}