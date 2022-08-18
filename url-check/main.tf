variable "url" {
  type = string
}

data "http" "aws-health" {
  url = var.url

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }

  lifecycle {
    postcondition {
      condition     = contains([201, 204], self.status_code)
      error_message = "${var.url} is unhealthy"
    }
  }
}
