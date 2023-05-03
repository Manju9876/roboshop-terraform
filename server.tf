
  resource "aws_instance" "instance_name" {
    for_each = var.component
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = each.value["name"]
  }
}


resource "aws_route53_record" "record" {
  for_each = var.component
  zone_id = "Z06653061K00JAPLVF5JM"
  name    = "${each.value["name"]}-dev.manju-devops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance_name[each.value["name"]].private_ip]
}
