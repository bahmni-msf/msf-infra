//# Block to get the already existing hostzone id
//data "aws_route53_zone" "ehealth-org" {
//  zone_id      = var.ZONE_ID
//  private_zone = true
//}
//#Block to create a record set, and assign domain to the elastic IP created
//resource "aws_route53_record" "server1-record" {
//  zone_id = data.aws_route53_zone.ehealth-org.zone_id
//  name    = "sample.ehealthunit.org"
//  type    = "A"
//  ttl     = "300"
//  records = [aws_eip.default.public_ip]
//}