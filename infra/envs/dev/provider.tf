terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    backend "s3" {
        bucket = "otel-terraform-state-bucket"
        key = "dev/vpc/terraform.tfstate"
        region = "us-east-1"
        //dynamodb_table = "otel-terraform-locks"
        use_lockfile = true
        encrypt = true
    }
}

provider "aws" {
    region = "us-east-1"
}

