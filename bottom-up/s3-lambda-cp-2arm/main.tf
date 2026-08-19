locals {
  handler_key = "gwlb/dual_arm_lifecycle_handler.py"
}

resource "aws_s3_bucket" "lambda_code" {
  bucket_prefix = "${var.deployment_prefix}-lambda-code-"

  tags = {
    Name = "${var.deployment_prefix}-lambda-code"
  }
}

resource "aws_s3_bucket_versioning" "lambda_code" {
  bucket = aws_s3_bucket.lambda_code.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_code" {
  bucket = aws_s3_bucket.lambda_code.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "handler" {
  bucket = aws_s3_bucket.lambda_code.id
  key    = local.handler_key
  source = "${path.module}/dual_arm_lifecycle_handler.py"
  etag   = filemd5("${path.module}/dual_arm_lifecycle_handler.py")

  depends_on = [aws_s3_bucket_versioning.lambda_code]
}
