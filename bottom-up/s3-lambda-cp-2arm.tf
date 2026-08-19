module "s3-lambda-cp-2arm" {
  source = "./s3-lambda-cp-2arm"
}

output "lambda_handler_bucket" {
  description = "S3 bucket name holding the Lambda handler code"
  value       = module.s3-lambda-cp-2arm.bucket_name
}

output "lambda_handler_key" {
  description = "S3 key of the Lambda handler"
  value       = module.s3-lambda-cp-2arm.object_key
}

output "lambda_handler_version" {
  description = "Latest uploaded version ID of the Lambda handler"
  value       = module.s3-lambda-cp-2arm.handler_version_id
}