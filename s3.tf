/*-------------
//S3 bucket creation
--------------*/
resource "aws_s3_bucket" "terraformBucket" {
  bucket        = "zephonixbucket"
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}