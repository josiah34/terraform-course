terraform {
  backend "s3" {
    bucket = "my-masterterraform"
    key    = "s3_backend.tfstate"
    region = "us-east-1"
  }
}
