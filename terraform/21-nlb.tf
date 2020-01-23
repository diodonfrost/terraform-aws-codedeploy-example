resource "aws_lb" "blue" {
  name               = "blue-green-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.vpc.private_subnets

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "blue" {
  port     = 80
  protocol = "TCP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "blue" {
  load_balancer_arn = aws_lb.blue.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}