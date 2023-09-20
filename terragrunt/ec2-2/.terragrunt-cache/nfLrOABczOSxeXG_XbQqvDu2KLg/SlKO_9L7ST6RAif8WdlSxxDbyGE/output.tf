output "web_server_ids" {
  value = aws_instance.web_servers[*].id
}

# Add other outputs as needed
