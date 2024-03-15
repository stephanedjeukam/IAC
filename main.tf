provider "aws" {
  region     = "${var.region}"
}

#1 -this will create a S3 bucket in AWS

resource "aws_s3_bucket" "terraform_state_s3_1" {
  bucket = "terraform-coachdevops-state-1" 

  tags = {
    Name        = "My bucket"
    Environment = "Devv"
  }

}


resource "aws_dynamodb_table" "terraform_locks" {
# Give unique name for dynamo table name
  name         = "tf-up-and-run-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
        attribute {
         name = "LockID"
         type = "S"
      }

}

terraform {
  backend "s3" {
    #Replace this with your bucket name!
    bucket         = "terraform-coachdevops-state-1"
    key            = "dc/s3/terraform.tfstate"
    region         = "us-east-1"
    #Replace this with your DynamoDB table name!
    dynamodb_table = "tf-up-and-run-locks"
    encrypt        = true
    }
}