# Example - cert expires within 30 days
resource "aws_api_gateway_client_certificate" "demo" {
  description = "My client certificate"

  lifecycle {
    postcondition {
      condition     = self.expiration_date < timeadd(timestamp(), "30 days")
      error_message = "cert ${self.id} expires within 30 days on ${self.expiration_date}"
    }
  }
}

# data "http" "example" {
#   url = "http://tfc.app.consul.hashicorp:443"

#   lifecycle {
#     postcondition {
#       condition     = self.ssl_certificate.expiration_date < timeadd(timestamp(), "30 days")
#       error_message = "http://tfc.app.consul.hashicorp:443 responds not ok"
#     }
#   }
# }
