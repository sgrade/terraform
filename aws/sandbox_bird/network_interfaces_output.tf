
data "aws_network_interfaces" "all_interfaces" {
  tags = {
    internal = true
  }
}

/*
output "interface_ids" {
  value = data.aws_network_interfaces.all_interfaces.ids
}
*/

data "aws_network_interface" "all" {
  for_each = data.aws_network_interfaces.all_interfaces.ids
  id = each.key
}

output "private_ips" {
  value = tomap({
    for int in data.aws_network_interface.all:
      int.id => int.private_ip
  })
}
