resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  tags = merge(var.common_tags, {
    Name = var.name
  })
}

resource "aws_route_table_association" "main" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.main.id
}

output "route_table_id" {
  value = aws_route_table.main.id
}

