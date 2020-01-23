resource "aws_launch_template" "blue" {
  image_id               = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.blue.id]
  user_data              = base64encode(file("scripts/userdata.sh"))
  iam_instance_profile {
    name = aws_iam_instance_profile.blue.name
  }
}

resource "aws_autoscaling_group" "blue" {
  vpc_zone_identifier       = module.vpc.private_subnets
  max_size                  = 15
  min_size                  = 4
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  wait_for_capacity_timeout = 0
  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }
  target_group_arns = [
    aws_lb_target_group.blue.arn
  ]
}
