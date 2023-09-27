#output "elb-dns-name" {
 #value = aws_lb.application-lb.dns_name
#}

output "web_server_security_group_id" {
  value = aws_security_group.alb_presentation_tier.id
}