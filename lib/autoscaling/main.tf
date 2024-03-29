resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = "${aws_iam_role.instance_instance_role.name}"
}

resource "aws_iam_role" "instance_instance_role" {
    name = "instance_instance_role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "instance_instance_policy" { 
    name = "instance_instance_policy"
    role = "${aws_iam_role.instance_instance_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:Get*",
            "s3:List*"
          ],
          "Resource": [
            "arn:aws:s3:::${var.deploy_s3_bucket}/*"
          ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.instance_group_name}_sg"
  description = "instance sg"
  vpc_id      = "${var.vpc_id}"
}

# We separate the rules from the aws_security_group because then we can manipulate the 
# aws_security_group outside of this module
resource "aws_security_group_rule" "instance_sg_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.instance_sg.id}"
  source_security_group_id = "${var.alb_security_group_id}"
}

# We separate the rules from the aws_security_group because then we can manipulate the 
# aws_security_group outside of this module
resource "aws_security_group_rule" "instance_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance_sg.id}"
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix          = "${var.instance_group_name}_lc"
  image_id             = "${var.aws_ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.instance_sg.id}"]
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install ruby -y
cd /home/ec2-user
sudo chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo service tomcat start
EOF
  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.id}"
  key_name             = "${var.key_name}"

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html 
resource "aws_autoscaling_group" "asg" {
  name                 = "${var.instance_group_name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.launch_configuration.id}"
  vpc_zone_identifier  = "${var.subnets}"
  # health_check_type         = "ELB"
  
  # A list of elastic load balancer names to add to the autoscaling group names. Only valid for classic load balancers
  # load_balancers       = ["${var.load_balancers}"]
  # 인스턴스의 Elastic Load Balancing 상태 확인을 사용하여 트래픽이 정상 인스턴스로만 라우트되는지 확인할 수 있습니다
  target_group_arns    = ["${var.alb_target_group_arn}"]
}