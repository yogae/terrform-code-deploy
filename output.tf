output "codedeploy_app_name" {
  value = "${module.code_deploy.codedeploy_app_name}"
}

output "codedeploy_deployment_group_name" {
  value = "${module.code_deploy.codedeploy_deployment_group_name}"
}