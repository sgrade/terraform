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

resource "local_file" "hosts" {
    content     = yamlencode(
      [for inst in aws_instance.router:
        inst.public_dns]
    )
    filename = "${path.module}/hosts.yml"
}
