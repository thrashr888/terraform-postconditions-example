# Example - a new health check API data source
# https://docs.aws.amazon.com/health/latest/ug/health-api.html
# https://status.aws.amazon.com/currentevents.json
# https://status.aws.amazon.com/historyevents.json

# data "aws_health" "ec2-check" {
#   region = "us-east-1"
#   service = "EC2"

#   lifecycle {
#     postcondition {
#       condition     = self.status == 0
#       error_message = "${self.region} ${self.service} is unhealthy"
#     }
#   }
# }

# Example - use the http source
# How can we sign the request?
data "http" "aws-health" {
  url = "https://health.us-east-1.amazonaws.com"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }

  lifecycle {
    postcondition {
      condition     = contains([201, 204], self.status_code)
      error_message = "us-east-1 is unhealthy"
    }
  }
}

variable "subscription_id" {
  type    = string
  default = ""
}
data "http" "azure-health" {
  url = "https://management.azure.com/subscriptions/${var.subscription_id}/providers/Microsoft.ResourceHealth/availabilityStatuses?api-version=2018-07-01&$expand=recommendedactions"

  request_headers = {
    Accept = "application/json"
  }

  lifecycle {
    postcondition {
      condition     = length(self.response_body) > 0
      error_message = "a subscription resource is unhealthy"
    }
  }
}

# data "http" "gcp-health" {
#   url = "https://status.cloud.google.com/incidents.json"

#   request_headers = {
#     Accept = "application/json"
#   }

#   lifecycle {
#     postcondition {
#       condition = length(filter_by(self.response_body, "status_impact", "SERVICE_DISRUPTION")) > 0
#       # i'm not sure how to check the json response list for only current disruptions. it might require new list functions
#       error_message = "a subscription resource is unhealthy"
#     }
#   }
# }
