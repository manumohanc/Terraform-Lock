provider "aws" {

  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

terraform {

  backend "s3" {
    bucket = "terraform.manumohan.online"
    dynamodb_table = "terraform-state-lock-dynamo"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }

}
