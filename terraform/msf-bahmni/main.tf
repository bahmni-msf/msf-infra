provider "aws" {
  version = "~> 2.0"
  alias      = "south"
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"
}
resource "aws_instance" "bahmni-sample-92" {
  ami           = "ami-0f453abffb073d28f"
  instance_type = "t2.micro"
}
