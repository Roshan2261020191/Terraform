vpc_cidr             = "11.0.0.0/16"
vpc_name             = "dev-proj-1-vpc"
subnet_count         = 2
eu_availability_zone = ["eu-north-1a","eu-north-1b"]
security_group_name = "public-security-group"

allowed_services = ["ssh", "http", "https"]

service_definitions = {
  ssh   = { protocol = "tcp", port = 22 }
  http  = { protocol = "tcp", port = 80 }
  https = { protocol = "tcp", port = 443 }
  # add more services if you want
}





