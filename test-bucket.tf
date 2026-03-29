terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use latest version if possible
    }
  }

  backend "s3" {
    bucket  = "shawn-terraform-state-2026"                 # Name of the S3 bucket
    key     = "jenkins-s3-test/terraform.tfstate"        # The name of the state file in the bucket
    region  = "us-east-1"                          # Use a variable for the region
    encrypt = true                                 # Enable server-side encryption (optional but recommended)
  } 
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true
  

  tags = {
    Name = "Jenkins Bucket"
  }
}

resource "aws_s3_object" "armageddon_approval" {
  bucket = aws_s3_bucket.frontend.id
  key    = "armageddon-approval.png"
  source = "${path.module}/files/armageddon-approval.png"
  etag   = filemd5("${path.module}/files/armageddon-approval.png")
}

resource "aws_s3_object" "repo_links" {
  bucket = aws_s3_bucket.frontend.id
  key    = "repo-links.rtf"
  source = "${path.module}/files/repo-links.rtf"
  etag   = filemd5("${path.module}/files/repo-links.rtf")
}