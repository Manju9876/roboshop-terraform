 locals {
   name= var.env != "" ? "${var.component_name}-${env}" :var.component_name
 }