
module "has-record-sets" {
  source   = "./has-record-sets"
  hostname = "hashicorp.com"
}

module "url-check" {
  source = "./url-check"
  url    = "http://hashicorp.com"
}
