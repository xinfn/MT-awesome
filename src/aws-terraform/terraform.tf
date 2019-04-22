terraform {
  required_version = ">= 0.11.13"

  backend "s3" {
    bucket = "ringle-private"
    region = "cn-northwest-1"
  }
}
