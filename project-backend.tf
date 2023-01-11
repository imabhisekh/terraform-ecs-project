terraform {
    backend "s3" {
       bucket = "abhi-terraform-backend"
       key    = "abhi.tfstate"
       region = "ap-south-1"
  }
}