# retrieve the region and availability zone data of the stack
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

# create network load balancer
resource "aws_lb" "network_load_balancer" {
  name               = "${var.project_name}-${var.environment}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]
  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-nlb"
  }
}

# https target group
resource "aws_lb_target_group" "nlb_https_target_group" {
  name        = "${var.project_name}-${var.environment}-https-tg"
  target_type = "instance"
  port        = 5601
  protocol    = "TLS"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = "5601"
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# create port 443 listener
resource "aws_lb_listener" "nlb_443_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.nlb_acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_https_target_group.arn
  }
}


# resource "aws_lb_target_group_attachment" "nlb_attachment" {
#   count            = var.number_of_instances
#   target_group_arn = aws_lb_target_group.nlb_https_target_group.arn
#   target_id        = aws_autoscaling_group.bfc-asg.id
#   port             = 5601
# }

# 6514 target group
resource "aws_lb_target_group" "nlb_6514_target_group" {
  name        = "${var.project_name}-${var.environment}-6514-tg"
  target_type = "instance"
  port        = 6514
  protocol    = "TLS"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = "6514"
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# create port 6514 listener
resource "aws_lb_listener" "nlb_6514_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = 6514
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.nlb_acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_6514_target_group.arn
  }
}

# resource "aws_lb_target_group_attachment" "nlb_6514_attachment" {
#   count            = var.number_of_instances
#   target_group_arn = aws_lb_target_group.nlb_6514_target_group.arn
#   target_id        = aws_autoscaling_group.bfc-asg.id
#   port             = 6514
# }

# 1514 target group
resource "aws_lb_target_group" "nlb_1514_target_group" {
  name        = "${var.project_name}-${var.environment}-1514-tg"
  target_type = "instance"
  port        = 1514
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = "1514"
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# create port 1514 listener
resource "aws_lb_listener" "nlb_1514_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = 1514
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_1514_target_group.arn
  }
}

# resource "aws_lb_target_group_attachment" "nlb_1514_attachment" {
#   count            = var.number_of_instances
#   target_group_arn = aws_lb_target_group.nlb_1514_target_group.arn
#   target_id        = aws_autoscaling_group.bfc-asg.id
#   port             = 1514
# }

# 1515 target group
resource "aws_lb_target_group" "nlb_1515_target_group" {
  name        = "${var.project_name}-${var.environment}-1515-tg"
  target_type = "instance"
  port        = 1515
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = "1515"
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# create port 1515 listener
resource "aws_lb_listener" "nlb_1515_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = 1515
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_1515_target_group.arn
  }
}

# resource "aws_lb_target_group_attachment" "nlb_1515_attachment" {
#   count            = var.number_of_instances
#   target_group_arn = aws_lb_target_group.nlb_1515_target_group.arn
#   target_id        = aws_autoscaling_group.bfc-asg.id
#   port             = 1515
# }
