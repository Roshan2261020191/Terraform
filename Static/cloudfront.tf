resource "aws_cloudfront_distribution" "zapzy_distribution" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name             = aws_s3_bucket.zapzy_bucket.bucket_regional_domain_name
    origin_id               = "zapzyS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.zapzy_oac.id

    s3_origin_config {
      origin_access_identity = ""  # must be empty when using OAC
    }
  }

  default_cache_behavior {
    target_origin_id       = "zapzyS3Origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
