output "codedeploy_app_name" {
  value = "${aws_codedeploy_app.code_deploy_app.name}"
}

output "codedeploy_deployment_group_name" {
  value = "${aws_codedeploy_deployment_group.deployment_group.name}"
}