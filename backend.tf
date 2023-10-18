# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "terraope-pl-terraform-state"
    key            = "terraops-pl-terraform-state/terraform.tfstate"
    region         = "us-east-1"
    profile        = "default"
    dynamodb_table = "terraform-state-lock"
  }
}
