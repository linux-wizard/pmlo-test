# tutorial-tf-gh
Test Terraform &amp; Github Actions &amp; Ansible
Goal:
- Deploy EC2 instances using Terraform - DONE
- Dynamically create SSH key to connect to instances - DONE
- Use ansible to install a web service (pgadmin4) - IN PROGRESS
- Create a RDS instance - DONE
- Pulling data from RDS - TODO
- Centralized logging - IN PROGRESS (using AWS Cloudwatch)

Note: we have the ability to decide how many instances of pgadmin4 we want to start

# Manual testing
In case you want to test your terraform locally, some preparations are needed.
Required components:
- terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli
- AWC CLI: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

As Terraform state will be stored in AWS S3 bucket, you will need to create a s3 bucket

## Environment variables
Please define following environment variables as they are needed by terraform
```shell

AWS_IAM_USER="AWS_IAM_USER"
AWS_ACCESS_KEY_ID="ASSOCIATED_IAM_USER_ACTIVE_AWS_ACCESS_KEY"
AWS_SECRET_ACCESS_KEY="ASSOCIATED_IAM_USER_SECRET_ACCESS_KEY"
AWS_DEFAULT_REGION="ap-southeast-1"
TF_VAR_env="prod"
TF_VAR_s3_bucket="pmlo-test"
TF_VAR_region="${AWS_DEFAULT_REGION}"
TF_VAR_dynamodb_tf_state_lock="tf-state-${AWS_DEFAULT_REGION}-${TF_VAR_env}-lock"
```
## Pre-requesite to store Terraform state in S3
Terraform state will be stored in a remote S3 bucket in order to protect sensitive information.

### Authenticate
```shell
aws configure
```

### Check your profile
```shell 
aws configure list
```

### Create S3 bucket
```shell
aws s3api create-bucket --bucket "${TF_VAR_s3_bucket}" \
 --region="${TF_VAR_region}" \
 --create-bucket-configuration LocationConstraint="${TF_VAR_region}"
```

### Enable versioning
```shell
aws s3api put-bucket-versioning --bucket "${TF_VAR_s3_bucket}" \
    --versioning-configuration Status=Enabled
```


You can check if the S3 bucket is created:
```shell
aws s3api list-buckets --query "Buckets[].Name"
aws s3api get-bucket-versioning --bucket "${TF_VAR_s3_bucket}"
```
### Create DynamoDB lock table
This Table will store lock to ensure safe concurrent access to Terraform State stored in S3. 
Free Tier is allocated up to 25 RCU/WCU for free, so we are going to limit to 20 RCU/WCU.
```shell
aws dynamodb create-table \
    --table-name "${TF_VAR_dynamodb_tf_state_lock}" \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=20,WriteCapacityUnits=20
```

You can check if the table is create and the schema using following commands:
```shell
aws dynamodb list-tables
aws dynamodb describe-table --table-name "${TF_VAR_dynamodb_tf_state_lock}"
```

## Run Terraform

### Validate configuration file
terraform validate

### Init terraform to install required providers
terraform init

### Check plan
terraform plan

### Apply
terraform apply

## SSH connection
### Extract SSH Private key from Teraform state
```shell
terraform show -json | jq .values.root_module.resources[].values.private_key_pem | grep -v null |  xargs printf "%b\n" > ~/.ssh/id-rsa-pmlo-test
chmod 600 ~/.ssh/id-rsa-pmlo-test
```

### Connect to an app server instance
ssh -i ~/.ssh/id-rsa-pmlo-test ec2-user@<INSTANCE_PUBLIC_IP>