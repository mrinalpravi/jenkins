terraform {
  backend "s3" {
    bucket = "utility-bucket-cloud-practice"
    key    = "terraform-backend/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  default_tags {
    tags = {
      Name        = "JenkinsServerSRE"
      Owner       = "Mrinal Ravi"
      Project     = "CICD"
      Environment = "IT-RnD"
      CostCenter  = "CDx"
      Client      = "CloudPractice"
    }
  }
  region = "us-east-1"
}
