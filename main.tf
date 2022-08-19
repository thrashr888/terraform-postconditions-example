variable "pet_name_length" {
  type    = number
  default = 5
}

resource "random_pet" "always_new" {
  lifecycle {
    postcondition {
      condition     = var.pet_name_length > 5
      error_message = "Name length must be greater than 5."
    }
  }

  keepers = {
    uuid = uuid() # Force a new name each time
  }
  length = var.pet_name_length
}
