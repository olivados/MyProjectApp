terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # Optional but recommended in production
    }
  }

  backend "s3" {
    bucket         = "wmao-project-register"
    key            = "jenkins/terraform.tfstate"
    region         = "us-east-2"

  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 3
  write_capacity = 3
  attribute {
    name = "LockID"
    type = "S"
  }
 tags = {
   Name = "Terraform Lock Table" #to destroy, add flag --lock=fasle
 }
 lifecycle {
   prevent_destroy = true #to destroy, change to false
 }
}

provider "aws" {
  region = "us-east-2"
}
