resource "aws_codedeploy_app" "code_deploy_app" {
  compute_platform = "Server"
  name             = "${var.application_name}"
}