variable "hostname" {
  type = string
}

# Example - hostname can be looked up using dns_a_record_set
data "dns_a_record_set" "default" {
  host = var.hostname

  lifecycle {
    postcondition {
      condition     = length(self.addrs) > 0
      error_message = "${var.hostname} DNS record does not contain any addresses"
    }
  }
}
