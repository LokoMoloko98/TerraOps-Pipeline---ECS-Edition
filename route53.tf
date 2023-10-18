resource "aws_route53_record" "www" {
  zone_id = var.route53_hosted_zone_id
  name    = "${var.project_name}-${var.environment}${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.network_load_balancer.dns_name
    zone_id                = aws_lb.network_load_balancer.zone_id
    evaluate_target_health = true
  }
}