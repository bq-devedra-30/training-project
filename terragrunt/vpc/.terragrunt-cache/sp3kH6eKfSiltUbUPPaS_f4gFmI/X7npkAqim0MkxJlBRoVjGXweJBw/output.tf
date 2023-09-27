output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnate_ids" {
  value = aws_subnet.private_subnet.*.id
}



output "public_subnete_ids" {
  value = aws_subnet.public_subnet.*.id
}

# output "main_vpc_id" {
#   value = aws_vpc.vpc.id
# }