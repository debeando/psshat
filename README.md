# Terraform AWS

## Requirements:

- AWS Credentials
- S3 Bucket to store terraform states.

## First steps

```bash
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION=<YOUR_REGION>
```

To set default variables for Terraform, add the `TF_VAR_` prefix for each
custom variables:

```bash
export TF_VAR_aws_region=$AWS_DEFAULT_REGION
export TF_VAR_aws_key_name=<KEY_NAME>
export TF_VAR_project=<PROJECT_NAME>
```

Initialize a Terraform working directory, download plugins and load modules:

```bash
make install
```

# Environment

Define the follow env variables for specific environment, for example:

```bash
export TF_VAR_env=sandbox
```

# Deploy

## Modules

```bash
terraform plan -target module.vpc
terraform apply -target module.vpc
```

## Number of instances

```bash
terraform apply -target module.proxysql -var 'proxysql.count=2'
```
