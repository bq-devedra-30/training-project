resource "aws_lb" "front_end" {
  name                       = "frontend-lb"
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  subnets                    = var.public_subnets_ids #module.vpc.public_subnets_ids
  security_groups            = [aws_security_group.alb_presentation_tier.id]
  #enable_deletion_protection = var.enable_deletion_protection
}

resource "aws_security_group" "alb_presentation_tier" {
  name        = var.aws_security_group_name
  description = "Allow HTTP requests"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = var.aws_security_group_protocol
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 3000
    to_port          = 3000
    protocol         = var.aws_security_group_protocol
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = 80
  protocol          = var.elb_protocol

  default_action {
    type             = var.default_action
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_lb_target_group" "front_end" {
  name     = var.aws_lb_target_group_front_end_name
  port     = 80
  protocol = var.aws_lb_target_group_protocol
  vpc_id   = var.vpc_id #module.vpc.main_vpc_id
  target_type = var.aws_lb_target_group_target_type

  health_check {
    path                = "/"    # Path for the health check on your instances
    healthy_threshold   = 2      # Number of consecutive successful checks to mark target as healthy
    unhealthy_threshold = 2      # Number of consecutive failures to mark target as unhealthy
 
   }
}


resource "aws_lb_target_group_attachment" "test" {
  count            = var.intance_count #length(aws_instance.web_servers)
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id        = var.instance_id[count.index] #aws_instance.web_servers[count.index].id   #aws_instance.web_servers.*.id
  port             = 80
}
