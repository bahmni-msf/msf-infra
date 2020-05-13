output "PrivateIPaddress" {
  value = aws_instance.bahmni.private_ip
}
output "Elasticip" {
  value = aws_eip.default.public_ip
}