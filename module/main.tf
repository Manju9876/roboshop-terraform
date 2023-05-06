
resource "aws_instance" "instance_name" {

  ami                     = data.aws_ami.centos.image_id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [data.aws_security_group.allow-all.id]


  tags = {
    Name = local.name
  }

}

resource "null_resource" "provisioner" {

  count      = var.provisioner ? 1 : 0
  depends_on = [aws_instance.instance_name, aws_route53_record.record]

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance_name.private_ip
    }

    inline = [
      "rm -rf roboshop-shell",
      "git clone https://github.com/Manju9876/roboshop-shell.git",
      "cd roboshop-shell",
      "sudo bash ${var.component_name}.sh ${var.password}"
    ]
  }
}

resource "aws_route53_record" "record" {
  zone_id  = "Z06653061K00JAPLVF5JM"
  name     = "${var.component_name}-dev.manju-devops.online"
  type     = "A"
  ttl      = 30
  records  = [aws_instance.instance_name.private_ip]
}



