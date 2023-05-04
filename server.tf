module "servers" {
  for_each = var.component

  source = "./module"
  component = each.value["name"]
  env = var.env
  instance_type = each.value["instance_type"]
  password = lookup(each.value, "password", "null")
}