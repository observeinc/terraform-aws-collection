# CloudFormation AWS Collection Infrastructure

This directory contains a Terraform module responsible for setting up the necessary infrastructure to allow GitHub Actions to release CloudFormation templates to an S3 bucket using OIDC for authentication. This ensures a seamless integration between the CI/CD pipeline and AWS services.

## Usage

Changes to this module are not automatically applied. After merging changes, you should manually apply them.

### Requirements

- **AWS Credentials**: Ensure that you have AWS credentials set up with permissions to create IAM roles, OIDC providers, and manage the specified S3 bucket.
  
- **GitHub Access Token**: Set the `GITHUB_TOKEN` environment variable to a GitHub access token with at least the `repo` scope. This token should also have permission to set repository secrets.

### Setup

1. Initialize the Terraform directory:
   
   ```bash
   terraform init
   ```

2. Verify your AWS identity to ensure you're acting as the expected user or role:

   ```bash
   aws sts get-caller-identity
   ```

   Check the output to ensure your ARN and account match your expectations.

3. Plan your Terraform changes:

   ```bash
   terraform plan -out=tfplan
   ```

   Review the plan to see what changes will be made. Make sure everything aligns with your intentions.

4. Apply the Terraform changes:

   ```bash
   terraform apply tfplan
   ```

   If everything looks correct, approve the changes to apply them.

### Destroy

To tear down the resources created by this module (use with caution):

```bash
terraform destroy
```

## Contents

### GitHub Actions Integration

- Sets up an OIDC provider in AWS to allow GitHub Actions to authenticate.
  
- Creates an IAM role with permissions that allow GitHub Actions to release CloudFormation templates to the specified S3 bucket.

- Configures GitHub Actions variables in the repository with the ARN of the IAM role so that it can be used.

### S3 Bucket Management

- Grants necessary permissions to the IAM role to read from and write to the specified S3 bucket.
