# VTI-project 

# I. Jenkins Pipeline for Spring Boot Application Deployment

This repository contains a Jenkins pipeline configuration for automating the deployment process of a Spring Boot application using Kubernetes and Docker. The pipeline follows a sequence of stages, each responsible for specific tasks to ensure a smooth and reliable deployment process.

## Pipeline Stages

### 1. Checkout Source
- This stage retrieves the source code from the version control system (e.g., GitHub) to be used in the deployment process.

### 2. Test
- In this stage, the application's unit tests are executed using the Gradle build tool. This ensures that the code is functioning as expected.

### 3. Build
- The application is built using the Gradle build tool, generating the necessary artifacts for deployment.

### 4. Build Image
- The Docker image of the application is created using the provided Dockerfile. This image will be used for running the application in a containerized environment.

### 5. Push Image
- The Docker image is tagged and pushed to a Docker registry. This step ensures that the image is accessible by the Kubernetes cluster during deployment.

### 6. Deploy Kubernetes Deployment
- The Kubernetes deployment configuration (`deployment.yaml`) is applied using the `kubectl` command. This stage ensures that the latest version of the application is deployed in the Kubernetes cluster.

## How to Use

1. **Clone Repository**
    - Clone this repository to your Jenkins server or relevant workspace.

2. **Configure Jenkins**
    - Set up Jenkins with proper credentials to access your version control system (e.g., GitHub) and Docker registry (e.g., Docker Hub).

3. **Create Pipeline**
    - In Jenkins, create a new pipeline job and link it to the cloned repository.

4. **Configure Docker and Kubernetes**
    - Ensure that Docker and Kubernetes are properly set up on the Jenkins server and the target environment.

5. **Configure Dockerhub Credentials**
    - Set up Dockerhub credentials in Jenkins to allow deployment to the Docker cluster.

6. **Configure GithubWebhook for Jenkin pipeline**
   - In your GitHub repository settings, navigate to "Webhooks" and create a new webhook.
   - Set the Payload URL to the Jenkins webhook URL. Make sure that the Jenkins server is accessible from the internet or use a service like ngrok for testing.
   - Choose "application/json" as the Content type.
   - Select the events you want to trigger the webhook: "push".
   - Save the webhook configuration.

7. **Run Pipeline**
    - Run the pipeline job in Jenkins. The defined stages will be executed sequentially to deploy your Spring Boot application to the Kubernetes cluster.

# II. Create a keypair and EC2 instance using terraform

This section provides instructions on how to use Terraform to create a keypair for your AWS EC2 instances. The keypair is an essential component for securely accessing your instances.

## Prerequisites

Before you begin, ensure that you have the following:

- An AWS account with appropriate permissions.
- Terraform installed on your local machine.

### 1. Create keypair on AWS 

**Step 1:** Create a file named `provider.tf` in the `terraform/keypair` directory and add the following content:

```hcl
provider "aws" {
  region = "us-east-1" # Update with your desired AWS region
  access_key = var.access_key
  secret_key = var.secret_key
  profile = "default"
  skip_region_validation = true
}
```


**Step 2:** Create a file named `variables.tf` in the `terraform/keypair` directory and add the following content:
```hcl
variable "access_key" {
  description = "AWS Access Key"
}

variable "secret_key" {
  description = "AWS Secret Key"
}

variable "key_pair_name" {
  description = "Key pair name"
}

variable "public_key" {
  description = "SSH Public Key"
}
```

**Step 3:** Create a file named `main.tf` in the `terraform/keypair` directory and add the following content:
```hcl
resource "aws_key_pair" "key_pair" {
   key_name   = var.key_pair_name
   public_key = var.public_key
}
```

**Step 4:** Run the following command to initialize Terraform:
```cmd
terraform init
```
**Step 5:** Run the following command to create the keypair:
```cmd
terraform apply
```
During this step, Terraform will prompt you to enter the following value
   - access_key: `Your AWS Access Key`
   - secret_key: `Your AWS Secret Key`
   - key_pair_name: `Name for the key pair you want to create`
   - public_key: `Your SSH Public Key`

Please enter the corresponding values from the keyboard once you see the prompt.

**Step 6:** If you want to delete the created resources, run the following command:
```cmd
terraform destroy
```


### 2. Create EC2 instance on AWS 
**Step 1:** Define variable in `variables.tf` file

```hcl
#Variables on the vti-demo workspace
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "INSTANCE_NAME" {}
#...

#Local variables
variable "ami_id" {
  description = "ami_id"
}
variable "instance_type" {
  description = "instance_type"
}

#...
```

**Step 2:** Create variable on workspace on Hashicorp cloud
- Login HashiCorp Cloud and navigate to the your workspace.
- In the workspace interface, select the "Variables" tab
- Click on the "Create Variable" button.
- Create variable with key `AWS_ACCESS_KEY` , `AWS_SECRET_KEY` ,... and enter the value for this variable

**Step 3:** Create file `terraform.tfvars` to assign value for local variables

```hcl
ami_id = "ami-091a58610910a87a9"
instance_type = "t2.medium"
key_pair_name = "eks_vutq_bastion-keypair"
```

**Step 4:** Declare providers in  `provider.tf` file

```hcl
provider "aws" {
  region     = var.aws_region 
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}
```

**Step 5:** Create file `terraform.tfvars` to assign value for local variables

```hcl
#provider value
aws_region = "ap-southeast-1"

#aws instance value
ami_id = "ami-091a58610910a87a9"
instance_type = "t2.medium"
key_pair_name = "eks_vutq_bastion-keypair"
security_group_id = "sg-00af2cb2877c86d41"
```

**Step 6:** Create EC2 Instance Resource in `main.tf`

```hcl
resource "aws_instance" "linux_ec2_instance" {
   ami           = var.ami_id  # Amazon Linux 2 AMI
   instance_type = var.instance_type
   key_name      = var.key_pair_name
   vpc_security_group_ids = [var.security_group_id]
   tags = {
      Name = var.INSTANCE_NAME
   }
}
```
**Step 7:** Create `output.tf` file to print some information from created EC2 instance

```hcl
#instance_id
output "instance_id" {
  value = aws_instance.linux_ec2_instance.id
}

# instance_arn
output "instance_arn" {
  value = aws_instance.linux_ec2_instance.arn
}
```

**Step 8:** Initialize and Apply:

```cmd
terraform init
terraform plan
terraform apply
```

**Step 9:** If you want to delete the created resources, run the following command:
```cmd
terraform destroy
```