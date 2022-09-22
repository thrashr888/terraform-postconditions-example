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

# check "cert-check" {
#   condition     = aws_api_gateway_client_certificate.demo.expiration_date < timeadd(timestamp(), "30 days")
#   error_message = "cert ${self.id} expires within 30 days on ${self.expiration_date}"
# }

# monitor "datadog-monitor" {
#   metrics_id = "678fdsay789f"
#   condition = self.unit == "gb" && self.util > "80%"
# }

# data "http" "example" {
#   url = "http://tfc.app.consul.hashicorp:443"

#   lifecycle {
#     postcondition {
#       condition     = self.ssl_certificate.expiration_date < timeadd(timestamp(), "30 days")
#       error_message = "http://tfc.app.consul.hashicorp:443 responds not ok"
#     }
#   }
# }


resource "tls_private_key" "example" {
  algorithm = "ECDSA"
}

# resource "tls_self_signed_cert" "example" {
#   private_key_pem = file("private_key.pem")

#   subject {
#     common_name  = "example.com"
#     organization = "ACME Examples, Inc"
#   }

#   validity_period_hours = 4380
#   early_renewal_hours   = 336

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]

#   lifecycle {
#     postcondition {
#       condition     = !self.ready_for_renewal
#       error_message = "Certificate will expire in less than two weeks."
#     }
#   }
# }


provider "tls" {
  proxy {
    url = "https://corporate.proxy.service"
  }
}

# data "tls_certificate" "example-test" {
#   url = "https://example.com"

#   lifecycle {
#     postcondition {
#       condition     = !self.ready_for_renewal
#       error_message = "Certificate will expire in less than two weeks."
#     }
#   }
# }

