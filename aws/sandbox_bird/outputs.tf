// Type "terraform output" to see the output

output "instance_dns_names" {
  value = tomap({
    for inst in aws_instance.router:
      inst.tags.Name => inst.public_dns
  })
}

output "instance_public_ips" {
  value = tomap({
    for inst in aws_instance.router:
      inst.tags.Name => inst.public_ip
  })
}

/*
// Ansible inventory in yaml format - needs some extra work
resource "local_file" "hosts" {
    content     = replace(
    yamlencode(
      tomap({
      "routers" = [for inst in aws_instance.router:
        inst.public_dns]
      })
    ),
    "\"", "")
    filename = "${path.module}/hosts.yml"
}
*/

// Ansible inventory in simple format. All hosts are in "ungrouped" default group
resource "local_file" "hosts" {
    content     = join("\n",
      [for inst in aws_instance.router:
        inst.public_dns]
    )
    filename = "${path.module}/hosts"
}
