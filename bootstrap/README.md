# Bootstrap — Terraform Remote State

Before running any workflow, you need to create the S3 bucket and DynamoDB lock table
that Terraform uses to store state. This is a one-time manual step done with admin credentials.

## Prerequisites

- AWS CLI configured with admin credentials (`--profile default` or env vars)
- Choose a globally unique bucket name (e.g. `franchise-api-tf-state-<account-id>`)

## 1. Create the S3 state bucket

```bash
BUCKET_NAME="franchise-api-tf-state-<YOUR_ACCOUNT_ID>"
AWS_REGION="us-east-1"

aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$AWS_REGION"

# Enable versioning (allows state recovery)
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# Block all public access
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Enable server-side encryption
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}
    }]
  }'
```

## 2. Create the DynamoDB lock table

The table name **must** match `backend.tf` → `dynamodb_table = "terraform-state-lock"`.

```bash
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$AWS_REGION"
```

## 3. Add secrets to GitHub

Go to **Settings → Secrets and variables → Actions** in the `franchise-iac` repository and add:

| Secret | Value |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | Access key for the CI/CD IAM user |
| `AWS_SECRET_ACCESS_KEY` | Secret key for the CI/CD IAM user |
| `TF_STATE_BUCKET` | The bucket name you created above |

## 4. IAM permissions for the CI/CD user

The IAM user used in CI/CD needs at minimum:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:CreateTable", "dynamodb:DeleteTable", "dynamodb:DescribeTable",
        "dynamodb:UpdateTable", "dynamodb:ListTagsOfResource", "dynamodb:TagResource",
        "dynamodb:UntagResource", "dynamodb:DescribeTimeToLive", "dynamodb:DescribeContinuousBackups"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:*:table/franchise-api-*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:CreateRepository", "ecr:DeleteRepository", "ecr:DescribeRepositories",
        "ecr:PutLifecyclePolicy", "ecr:GetLifecyclePolicy", "ecr:ListTagsForResource",
        "ecr:TagResource", "ecr:UntagResource", "ecr:PutImageScanningConfiguration",
        "ecr:PutImageTagMutability"
      ],
      "Resource": "arn:aws:ecr:us-east-1:*:repository/franchise-api-*"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::YOUR_BUCKET_NAME",
        "arn:aws:s3:::YOUR_BUCKET_NAME/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:*:table/terraform-state-lock"
    }
  ]
}
```
