resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = var.name
  })
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}

