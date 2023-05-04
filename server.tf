
  resource "aws_instance" "instance_name" {
    for_each = var.component
    ami           = data.aws_ami.centos.image_id
    instance_type = each.value["instance_type"]
    vpc_security_group_ids = [data.aws_security_group.allow-all.id]


    tags = {
      Name = each.value["name"]
    }


  }
  resource "null_resource" "provisioner" {

    depends_on = [aws_instance.instance_name, aws_route53_record.record]
    for_each   = var.component

    provisioner "remote-exec" {

      connection {
        type     = "ssh"
        user     = "centos"
        password = "DevOps321"
        host     = aws_instance.instance_name[each.value["name"]].private_ip
      }

      inline = [
        "rm -rf roboshop-shell",
        "git clone https://github.com/Manju9876/roboshop-shell.git",
        "cd roboshop-shell",
        "sudo bash ${each.value["name"]}.sh ${each.value["password"]}"
      ]
    }
  }

  resource "aws_route53_record" "record" {
      for_each = var.component
      zone_id  = "Z06653061K00JAPLVF5JM"
      name     = "${each.value["name"]}-dev.manju-devops.online"
      type     = "A"
      ttl      = 30
      records  = [aws_instance.instance_name[each.value["name"]].private_ip]
  }

