# resource "aws_api_gateway_client_certificate" "demo" {
#   description = "My client certificate"

#   lifecycle {
#     postcondition {
#       condition     = parsedate(self.demo.expiration_date, "2017-06-15T22:33:13Z") < timeadd(timestamp(), "30d")
#       error_message = "cert ${self.id} expires within 30 days on ${self.expiration_date}"
#     }
#   }
# }
