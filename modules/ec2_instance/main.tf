resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      network_interface_id = network_interface.value.network_interface_id
      device_index         = network_interface.value.device_index
    }
  }

  tags = merge(var.common_tags, {
    Name = var.name
  })
}

output "instance_id" {
  value = aws_instance.main.id
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

