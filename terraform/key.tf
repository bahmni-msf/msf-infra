resource "aws_key_pair" "mynewkey" {
  key_name   = "mynewkey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
