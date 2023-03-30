data "aws_route53_zone" "selected" {
  name         = "${var.zone_name}"
  private_zone = false
}



resource "aws_route53_record" "webapprecord" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"
  ttl     = 60
  records = ["${var.ec2_ip}"]
}
