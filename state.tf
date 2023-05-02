terraform {
  backend "s3" {
    bucket = "terraform-200127"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}