output "target_group_arn" {
  value = "${aws_alb_target_group.default.arn}"
}

output "target_group_name" {
  value = "${aws_alb_target_group.default.name}"
}

output "security_group_id" {
  value = "${aws_security_group.alb_sg.id}"
}

output "listener_arn" {
  value = "${aws_alb_listener.http.arn}"
}

