# Example - server returns 2XX
data "http" "consul-status-example" {
  url = "http://tfc.app.consul.hashicorp:443"

  lifecycle {
    postcondition {
      condition     = self.status_code >= 200 && self.status_code < 300
      error_message = "http://tfc.app.consul.hashicorp:443 responds not ok"
    }
  }
}

# Example - server is reachable via a proxy
data "http" "proxy-example" {
  url = "https://tfc.app.consul.hashicorp"

  request_headers = {
    Proxy = "https://proxy.consul.hashicorp"
  }

  lifecycle {
    postcondition {
      condition     = self.status_code >= 200 && self.status_code < 300
      error_message = "https://tfc.app.consul.hashicorp responds not ok via proxy https://proxy.consul.hashicorp"
    }
  }
}

# Example - hostname can be looked up using dns_a_record_set
data "dns_a_record_set" "tfc-internal" {
  host = "hashicorp.com"

  lifecycle {
    postcondition {
      condition     = length(self.addrs) > 0
      error_message = "hashicorp.com DNS record does not contain any  addresses"
    }
  }
}

# Example - hostname can be looked up using a func
# monitor "dns-record" {
#   condition     = dns_record("tfc.app.consul.hashicorp") 
#   error_message = "tfc.app.consul.hashicorp DNS record not found"
# }

# Example - DNS zone has records in it
data "azurerm_dns_zone" "example" {
  name                = "search-eventhubns"
  resource_group_name = "search-service"

  lifecycle {
    postcondition {
      condition     = self.number_of_record_sets > 0
      error_message = "${self.id} DNS zone does not contain any records"
    }
  }
}
