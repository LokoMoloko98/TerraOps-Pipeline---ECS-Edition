# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "barefootcyber-terraform-state-file"
    key            = "barefootcyber-uat-state/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "moloko@barefootcyber.com"
    dynamodb_table = "terraform-state-lock"
  }
}
