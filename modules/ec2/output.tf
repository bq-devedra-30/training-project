output "web_server_ids" {
  value = aws_instance.web_servers[*].id
}

# Add other outputs as needed

output "web_server_security_group_id" {
  value = aws_security_group.web_server_security_group.id
}
