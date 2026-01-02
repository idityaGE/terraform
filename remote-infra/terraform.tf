terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.0"
    }
  }

  backend "s3" {
    bucket = "remote-infra-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "remote_infra_lock_table"
    use_lockfile   = true
    profile        = "localstack"
    use_path_style = true
  }  
}

provider "aws" {
  profile           = "localstack"
  region            = "us-east-1"
  s3_use_path_style = true
}


