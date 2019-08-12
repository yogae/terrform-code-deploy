
resource "aws_iam_role" "code_deploy_role" {
  name = "code-deploy-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.code_deploy_role.name}"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = "${aws_codedeploy_app.code_deploy_app.name}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name  = "${var.deployment_group_name}"
  service_role_arn       = "${aws_iam_role.code_deploy_role.arn}"
  autoscaling_groups     = "${var.autoscaling_groups}"
  
  deployment_style {
    # LoadBalancerInfo에 지정된 속성을 사용하려면 WITH_TRAFFIC_CONTROL로 설정
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    # 트래픽을 대체 환경으로 즉시 다시 라우팅하거나 다시 라우팅 프로세스를 수동으로 시작할 때까지 기다릴지 여부를 선택합니다.
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }

    # 배포에 성공한 다음 원본 환경의 인스턴스를 종료할지 여부와 종료 전 대기 시간을 선택합니다.
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  load_balancer_info {
    target_group_info {
      name = "${var.alb_target_group_name}"
    }
  }
}