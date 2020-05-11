resource "aws_instance" "bahmni" {
  instance_type = var.INSTANCE_TYPE
  ami = var.AMI_ID
  tags = {
    Name = "Bahmni-Image-2"
  }
  key_name = aws_key_pair.mykey.key_name
  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo sed -i -e 's/\r$//' /tmp/script.sh",
      # Remove the spurious CR characters.
      "sudo /tmp/script.sh",
    ]
  }
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}
# To create a new eip and assign it to the instance created.
resource "aws_eip" "default" {
  instance = aws_instance.bahmni.id
}