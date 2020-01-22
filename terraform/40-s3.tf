resource "aws_s3_bucket" "codeploy_artefact" {
  bucket = "this-bucket-is-use-for-store-artefact-codedeploy"
  acl    = "private"
}

resource "aws_s3_bucket_object" "codeploy_artefact" {
  bucket = aws_s3_bucket.codeploy_artefact.id
  key    = "SampleApp_Linux.zip"
  source = "application/SampleApp_Linux.zip"
}
