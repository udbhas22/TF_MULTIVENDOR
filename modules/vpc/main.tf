resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = merge(var.common_tags, {
    Name = var.name
  })
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

