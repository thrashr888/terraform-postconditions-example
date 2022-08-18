
# https://discuss.hashicorp.com/t/terraform-core-current-research-projects/37765/2
variable "instance_count" {
  type    = number
  default = 1
}
variable "expected_count" {
  type    = number
  default = 1
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "instances" {
  count         = var.instance_count
  instance_type = "t3.micro"
  ami           = data.aws_ami.ubuntu.id
}

output "api_base_url" {
  value = [for s in aws_instance.instances : s.id]

  precondition {
    condition     = length(aws_instance.instances) == var.expected_count
    error_message = "Expected ${var.expected_count} instances, got ${length(aws_instance.instances)}"
  }
}
