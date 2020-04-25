variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "ap-south-1"
}
variable "bahmni_image_92" {
  description = "Bahmni Image for 92 Version"
  default     = "ami-0f453abffb073d28f"
}
variable "instance_type" {
  description = "Type of AWS instance"
  default     = "t2.micro"
}
