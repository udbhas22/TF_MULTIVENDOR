resource "aws_subnet" "main" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = merge(var.common_tags, {
    Name = var.name
  })
}

output "subnet_id" {
  value = aws_subnet.main.id
}

output "subnet_cidr_block" {
  value = aws_subnet.main.cidr_block
}

