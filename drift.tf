# Example - problematic drift occurs
resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"

  lifecycle {
    postcondition {
      condition     = self.acl == "private"
      error_message = "${aws_s3_bucket.b.bucket} is no longer private"
    }
  }
}
