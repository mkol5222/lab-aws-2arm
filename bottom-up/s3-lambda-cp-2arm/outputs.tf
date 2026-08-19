output "bucket_name" {
  description = "Name of the S3 bucket holding Lambda handler code"
  value       = aws_s3_bucket.lambda_code.id
}

output "object_key" {
  description = "S3 key of the uploaded Lambda handler"
  value       = aws_s3_object.handler.key
}

output "handler_version_id" {
  description = "S3 version ID of the uploaded handler (use as initial S3_VERSION_ID)"
  value       = aws_s3_object.handler.version_id
}
