terraform {
  backend "s3" {
    bucket         = "devopsninja"   
    key            = "terraform/terraform.tfstate"     
    region         = "ap-south-1"              
    encrypt        = true
    
  }
}
