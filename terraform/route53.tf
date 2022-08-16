resource "aws_route53_record" "code_server_a_record" {
  # this resource is created only when all variables exist
  count = (var.domain_zone_id != "" && var.domain_name != "") ? 1 : 0

  zone_id = var.domain_zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.code_server_public_ip.public_ip]
}
