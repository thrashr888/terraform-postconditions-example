# +--------------------------+--------+------------------------------------------------+
# |         Resource         | Status |                    Message                     |
# +--------------------------+--------+------------------------------------------------+
# | aws_ami.ubuntu           | Passed |                                                |
# | aws_instance.web         | Passed |                                                |
# | aws_key_pair.web         | Passed |                                                |
# | tls_self_signed_cert.web | Failed | Certificate will expire in less than 12 hours. |
# +--------------------------+--------+------------------------------------------------+

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"] # Canonical

#   lifecycle {
#     postcondition {
#       condition     = self.state == "available"
#       error_message = "The AMI is not available."
#     }
#   }
# }

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.web.key_name

  lifecycle {
    postcondition {
      condition     = self.public_dns != ""
      error_message = "Instance ${self.id} is not ready"
    }
  }
}

resource "aws_key_pair" "web" {
  key_name   = "web-key"
  public_key = tls_self_signed_cert.web.cert_pem

  lifecycle {
    postcondition {
      condition     = self.fingerprint != ""
      error_message = "Key ${self.id} is not ready"
    }
  }
}

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

resource "tls_self_signed_cert" "web" {
  private_key_pem = file("private_key.pem")
  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
  early_renewal_hours = 4
  validity_period_hours = 8
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  lifecycle {
    postcondition {
      condition     = !self.ready_for_renewal
      error_message = "Certificate will expire in less than 4 hours"
    }
  }
}
