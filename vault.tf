# +-----------------------------------+--------+------------------------------+
# |         Resource                  | Status |           Message            |
# +-----------------------------------+--------+------------------------------+
# | aws_ami.ubuntu                    | Passed |                              |
# | aws_instance.web                  | Passed |                              |
# | aws_key_pair.web                  | Passed |                              |
# | vault_pki_secret_backend_cert.web | Failed | Certificate requires renewal |
# +-----------------------------------+--------+------------------------------+

resource "vault_pki_secret_backend_cert" "web" {
  backend = "intermediate-ca"
  name    = "admin-role"
  common_name = "es-master-1.company.internal"
  ttl         = "1h"

  lifecycle {
    postcondition {
      condition     = !self.renew_pending
      error_message = "Certificate requires renewal"
    }
  }
}