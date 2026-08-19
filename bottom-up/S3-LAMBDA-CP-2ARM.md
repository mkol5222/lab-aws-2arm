# S3 Lambda Code Bucket — `s3-lambda-cp-2arm` Module

## Purpose

This module provisions an S3 bucket that hosts the Lambda handler code for the Check Point dual-ARM GWLB autoscale solution. Instead of pulling code from the vendor-managed `cgi-cfts-staging` bucket, the deployment uses a privately owned bucket in the same AWS account and region (`eu-central-1`).

The Lambda function deployed by the `autoscale_gwlb_dual_arm` module uses a **bootstrap loader pattern**:

```
Lambda invoked
  └─ lambda_s3_loader.py  (bundled in Lambda zip — the bootstrap)
       └─ downloads dual_arm_lifecycle_handler.py from S3
            └─ exec() → calls lambda_handler(event, context)
```

The bucket created here serves as the source for the second step.

## Resources Created

| Resource | Description |
|---|---|
| `aws_s3_bucket.lambda_code` | Bucket with name prefix `chkpdemo-lambda-code-` |
| `aws_s3_bucket_versioning` | Versioning enabled — required for `S3_VERSION_ID` pinning |
| `aws_s3_bucket_server_side_encryption_configuration` | AES-256 server-side encryption |
| `aws_s3_bucket_public_access_block` | Managed by org-level SCP — not set by Terraform |
| `aws_s3_object.handler` | Uploads `dual_arm_lifecycle_handler.py` to `gwlb/dual_arm_lifecycle_handler.py` |

## Outputs

| Output | Description |
|---|---|
| `bucket_name` | Bucket ID passed to the Lambda env var `S3_BUCKET` |
| `object_key` | Object key (`gwlb/dual_arm_lifecycle_handler.py`) passed to `S3_KEY` |
| `handler_version_id` | S3 version ID of the uploaded object — the bootstrap pins this to `S3_VERSION_ID` on first run |

## How It Wires Into the Stack

```
module.s3-lambda-cp-2arm
    .bucket_name  ──►  module.fw (fw.tf)
    .object_key   ──►    └─ fw/variables.tf: s3_bucket, s3_key
                               └─ fw/cpfw.tf → autoscale_gwlb_dual_arm
                                    └─ Lambda env vars: S3_BUCKET, S3_KEY
                                    └─ IAM policy: s3:GetObject on bucket/key
```

`module.fw` declares `depends_on = [module.s3-lambda-cp-2arm]` to ensure the bucket and object exist before Lambda is deployed.

## Version Pinning Behaviour

On first Lambda invocation, `lambda_s3_loader.py` fetches the latest S3 object version and self-pins it by writing `S3_VERSION_ID` into the Lambda's own environment variables. Subsequent invocations use that pinned version.

To **update the handler** after changing `dual_arm_lifecycle_handler.py`:

1. Run `terraform apply -target module.s3-lambda-cp-2arm` — uploads the new file, creates a new S3 version.
2. Manually update `S3_VERSION_ID` in the Lambda environment variables in the AWS Console, **or** set `LAMBDA_AUTO_UPDATE=true` temporarily and invoke once.

## Deployment Order

```shell
# in bottom-up/
# cd bottom-up
terraform init -upgrade
terraform apply -target module.s3-lambda-cp-2arm -auto-approve
terraform apply -target module.net -auto-approve
terraform apply -target module.management -auto-approve
terraform apply -target module.fw -auto-approve
terraform apply -target module.instances -auto-approve
```

The `Makefile` enforces this order via `make up`.

## Teardown Order

```shell
terraform destroy -target module.instances -auto-approve
terraform destroy -target module.fw -auto-approve
terraform destroy -target module.management -auto-approve
terraform destroy -target module.net -auto-approve
terraform destroy -target module.s3-lambda-cp-2arm -auto-approve
```

> **Note:** The S3 bucket must be emptied before destroy will succeed if versioning has created multiple object versions. Run `aws s3 rm s3://<bucket-name> --recursive` first, or enable a bucket lifecycle rule to expire old versions.

## Validating Access to the Bucket

The bucket blocks all public access. Downloads require valid AWS credentials with `s3:GetObject` (and `s3:GetObjectVersion` for versioned reads). The commands below assume credentials are configured via environment variables, `~/.aws/credentials`, or an IAM role.

### 1. Get the bucket name from Terraform output

```shell
# in bottom-up/
BUCKET=$(terraform output -raw lambda_handler_bucket)
KEY=$(terraform output -raw lambda_handler_key)
VERSION=$(terraform output -raw lambda_handler_version)

echo "Bucket:  $BUCKET"
echo "Key:     $KEY"
echo "Version: $VERSION"
```

### 2. Download the latest version

```shell
aws s3 cp s3://$BUCKET/$KEY /tmp/dual_arm_lifecycle_handler.py
```

Expected output:
```
download: s3://<bucket>/gwlb/dual_arm_lifecycle_handler.py to /tmp/dual_arm_lifecycle_handler.py
```

### 3. Download a specific pinned version

This mirrors exactly what the Lambda bootstrap does when `S3_VERSION_ID` is set:

```shell
aws s3api get-object \
  --bucket $BUCKET \
  --key $KEY \
  --version-id $VERSION \
  /tmp/dual_arm_lifecycle_handler.py

# confirm the VersionId in the response matches
```

### 4. Verify versioning is enabled and list object versions

```shell
aws s3api list-object-versions \
  --bucket $BUCKET \
  --prefix $KEY \
  --query 'Versions[*].{VersionId:VersionId,LastModified:LastModified,IsLatest:IsLatest}' \
  --output table
```

### 5. Verify the downloaded file matches the local source

```shell
md5sum /tmp/dual_arm_lifecycle_handler.py
md5sum bottom-up/s3-lambda-cp-2arm/dual_arm_lifecycle_handler.py
# both hashes must match
```

### 6. Confirm public access is blocked (expected to fail with 403)

```shell
# This should return: An error occurred (403) when calling the HeadObject operation
aws s3api head-object \
  --bucket $BUCKET \
  --key $KEY \
  --no-sign-request 2>&1 || echo "Access correctly denied for unauthenticated requests"
```

### 7. Check bucket encryption and public-access block config

```shell
aws s3api get-bucket-encryption --bucket $BUCKET \
  --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault'

aws s3api get-public-access-block --bucket $BUCKET
```

Expected encryption output:
```json
{
    "SSEAlgorithm": "AES256"
}
```

Public-access block is enforced by the organization SCP (`s3:PutBucketPublicAccessBlock` is denied to account users), so Terraform does not manage it. Verify it is active at the org level:

```shell
aws s3api get-public-access-block --bucket $BUCKET
# Expected: all four flags true, enforced by SCP arn:aws:organizations::141235525282:policy/.../p-m3zkif2x
```
