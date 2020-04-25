provider "aws" {
  access_key = ""
  secret_key = ""
  region     = var.aws_region
}
resource "aws_instance" "bahmni-sample-92" {
  ami           = var.bahmni_image_92
  instance_type = var.instance_type
}
