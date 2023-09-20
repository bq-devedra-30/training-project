resource "aws_lb" "front_end" {
  name = var.aws_lb_name
  internal = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    =   ["${var.security_group_id}"] #module.vpc.security_group_id
  subnets             =  var.public_subnets_ids #module.vpc.public_subnets_ids

  enable_deletion_protection = var.enable_deletion_protection
  
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
  name = var.aws_lb_target_group_front_end_name
  port   = 80
  protocol = var.aws_lb_target_group_protocol
  vpc_id   = var.vpc_id #module.vpc.main_vpc_id
}


resource "aws_lb_target_group_attachment" "test" {
  count             = var.intance_count #length(aws_instance.web_servers)
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id      = var.instance_id #aws_instance.web_servers[count.index].id   #aws_instance.web_servers.*.id
  port             = 80
}
