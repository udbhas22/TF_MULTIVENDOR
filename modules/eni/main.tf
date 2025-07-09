resource "aws_network_interface" "main" {
  subnet_id   = var.subnet_id
  private_ips = [var.private_ip]
  security_groups = var.security_group_ids

  tags = merge(var.common_tags, {
    Name = var.name
  })
}

output "eni_id" {
  value = aws_network_interface.main.id
}

output "eni_private_ip" {
  value = aws_network_interface.main.private_ip
}

