provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

resource "random_id" "random" {
  byte_length = 8
}

resource "aws_s3_bucket" "demo_s3" {
  bucket = "raj-${random_id.random.hex}"
}

resource "aws_s3_object" "bucket_data" {
  for_each = fileset(var.local_website_folder, "**")

  bucket = aws_s3_bucket.demo_s3.bucket
  key    = each.value
  source = "${var.local_website_folder}/${each.value}"

  etag                   = filemd5("${var.local_website_folder}/${each.value}")
  server_side_encryption = "AES256"
}
