
# Example - name wasn't changed by the server
variable "instance_name" {
  type    = string
  default = "~My SiLlY LOOOOOOOOOOOOOOOOOOOONG NAAaaaaaaaME-"
}
resource "aws_instance" "example" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.ubuntu.id

  tags = {
    Name = var.instance_name
  }

  lifecycle {
    postcondition {
      condition     = var.instance_name == self.tags.Name
      error_message = "name was changed after applying"
    }
  }
}

# Example - db engine version wasn't changed by the server
resource "aws_db_instance" "default" {
  allocated_storage           = 10
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  db_name                     = "mydb"
  username                    = "foo"
  password                    = "foobarbaz"
  parameter_group_name        = "default.mysql5.7"
  skip_final_snapshot         = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false

  lifecycle {
    postcondition {
      condition     = self.engine_version_actual < 6
      error_message = "${self.db_name} db engine version has been upgraded past 5.7.10"
    }
  }
}
