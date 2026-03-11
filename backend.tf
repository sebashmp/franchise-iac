terraform {
  backend "s3" {
    # bucket and key are injected at runtime via -backend-config flags in CI/CD:
    #   -backend-config="bucket=<TF_STATE_BUCKET secret>"
    #   -backend-config="key=<env>/terraform.tfstate"
    #
    # The S3 bucket and DynamoDB lock table must exist before running any workflow.
    # See bootstrap/README.md for creation instructions.
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
