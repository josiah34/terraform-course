# Notes on Storing Terraform State on a Remote Backend 




- In a production environment we usually use store the state file remotely instead of locally. The reason for this is to prevent conflicts and the corruption of the state file. For example say you have a team of Developers who all have a local copy of a state file. Developer A destroys a resource while Developer B is modifiying that resource. 





### Storing State File on an AWS S3 Bucket

1. Creating the S3 Bucket. Also I enable versioning so that if the state file becomes corrupted I can revert back to an older version. 

![s3-bucket](https://github.com/josiah34/terraform-course/assets/25124463/ff8045eb-f382-48c4-aacc-c1850ad70e2e)

2. Create a backend tf terraform block in your terraform project folder. This is the default block provided from the official documentation. Change the values to match your configuration. 

```
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
```

3. Initialize using ``terraform init``. Once initialized do a ``terraform apply -auto-approve``.

4. You'll notice that this time after resource creation that no local state file is created. Instead it is stored on the S3 bucket that was created. 
5.  ![remote-state](https://github.com/josiah34/terraform-course/assets/25124463/5bcda016-1420-43bb-a207-432bef38e6b0)

6. We will have to create a DynamoDB table to enable state locking to prevent concurrent writes to the state file. 
7. We will also have to change the backend block in the terraform code. **Note the new dynamodb_table within the block**

```
terraform {
  backend "s3" {
    bucket = "my-masterterraform"
    key    = "s3_backend.tfstate"
    dynamodb_table = "s3-state-lock"
    region = "us-east-1"
  }
}
```

8. Now when we try to do two operations at the same time we will get an error. 


### Terraform Cloud 

We can also create a Terraform Cloud account to store the state file there. After account creation make a new organization. 

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "master-terraform-jg"
    workspaces {
      name = "terraform-cloud"
    }
  }
}

```

Next use the ``terraform login`` command to authenticate to your terraform cloud account. After that I created a variable set on my Terraform Cloud which I enabled globally for all my workspaces. Then added my AWS credentials as environment variables. Make sure to mark them as sensitive so they do not show in plain text in any logs. 

