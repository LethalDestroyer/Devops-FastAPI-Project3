resource "aws_lb" "app_alb" {
  name = "${var.project}-alb"
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnet_ids
  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Name = "${var.project}-alb"
  }
}

resource "aws_security_group" "alb_sg" {
  name = "${var.project}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

# This will create targetgroup
resource "aws_lb_target_group" "tg" {
  name = "${var.project}-tg"
  port = 8000
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${var.project}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "name" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = var.instance_id
  port = 8000
}