data "aws_route53_zone" "selected" {
  name         = var.zone_name
  private_zone = false
}



resource "aws_route53_record" "webapprecord" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"
  #records = [data.aws_lb.webapplb.dns_name]

alias {
  zone_id = data.aws_lb.webapplb.zone_id
  name    = data.aws_lb.webapplb.dns_name
  evaluate_target_health = true
}

}
