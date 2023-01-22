# Terraform lock with DynamoDB and backend S3
## How to Lock Terraform State with S3 bucket in DynamoDB.

Terraform must keep track of the configuration and managed infrastructure you have in place. Terraform makes use of this state file to coordinate real-world resources with your configuration, manage metadata, and boost speed for sizable infrastructures. In order for Terraform to know what it is managing, this state file, which maps different resource metadata to actual resource IDs, is of utmost importance. Anyone who might run this Terraform code has to have this file.

Terraform by default saves state locally in a file with the name terraform.tfstate. Using a local file complicates Terraform usage when using it in a team because each user must ensure they always have the most recent state data before running Terraform and that no one else runs Terraform at the same time.

With remote state, Terraform writes the state data to a remote data store, which can then be shared between all members of a team. Terraform will lock your state for all operations that could write. This stops others from obtaining the lock and possibly tainting your state.

## Prerequisites

- Create an S3 bucket with versioning enabled
- Create 2 EC2 instances
- Create a role to access the S3 bucket and DynamoDB and assign it to both instances
- Download and configure terraform on both instnaces


## Setup S3 Backend

```sh
terraform {
  backend "s3" {
    bucket = "Bucket Name"
    dynamodb_table = "DynamoDB table name"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
```

## Creating DynamoDB Table.

```sh
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
}
```


Initially I had to run terraform apply with -lock=false as this was the first time running this and there was no lock file present and the dynamoDB was yet to be created.

```sh
$ terraform apply -lock=false
Plan: 1 to add, 0 to change, 0 to destroy.
aws_dynamodb_table.dynamodb-terraform-state-lock: Creating...
aws_dynamodb_table.dynamodb-terraform-state-lock: Creation complete after 7s [id=terraform-state-lock-dynamo]
```

Added code to create a new Security group to the infra. Copied all these codes to second instance as well. Now in the first instance did a terraform apply. Terraform now shows that new security group will be created and then I get the confirmation prompt. Without giving any confirmation I logged into the second instance. Here I installed and initialized terraform in the working directory and then tried to do a terraform plan and as expected got an error acquiring state lock. 

```sh
[ec2-user@docker int-task]$ terraform plan
╷
│ Error: Error acquiring the state lock
│
│ Error message: ConditionalCheckFailedException: The conditional request failed
│ Lock Info:
│   ID:        5ab98e40-03c9-0359-193d-6336ef827ddb
│   Path:      terraform.manumohan.online/terraform.tfstate
│   Operation: OperationTypeApply
│   Who:       ec2-user@ip-172-31-35-45.ap-south-1.compute.internal
│   Version:   1.3.6
│   Created:   2023-01-22 08:29:14.526147392 +0000 UTC
│   Info:
│
│
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue above and try
│ again. For most commands, you can disable locking with the "-lock=false"
│ flag, but this is not recommended.
```
 
This will ensure that when multiple people are working with same code, it will prevent others from acquiring the lock and prevent users from corrupting the state. 









