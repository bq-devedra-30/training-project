 output "vpc_id" {
   value = aws_vpc.main.id
 }

# output "subnet_ids" {
#   value = ""
# }

# # output "aws_security_group" {
# #   value = aws_security_group.web_sg.id
# # }

# output "availability_zone_names" {
#   value = data.aws_availability_zones.available.names
# }

output "private_subnate_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "security_group_id" {
  value = aws_security_group.alb_presentation_tier.id
  
}

output "public_subnets_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "main_vpc_id" {
  value = aws_vpc.main.id
}