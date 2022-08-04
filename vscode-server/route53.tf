resource "aws_route53_record" "code_server_a_record" {
  # 變數都存在才會建立此資源
  count = (var.domain_zone_id != "" && var.domain_name != "") ? 1 : 0

  zone_id = var.domain_zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [aws_eip.code_server_public_ip.public_ip]
}
