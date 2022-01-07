# Terraform AWS Workshop

We setup an AWS Infrastructure with Terraform.
It sets up a Terraform configuration for defining one single **AWS EC2 instance**.
This EC2 instance shall run three Docker container using **AWS ECS**.
The containers run on different ports of the EC2 instance and contain various web applications in Node.js,
HTML, JS and PHP.

# Software Requirements
- Terraform 1.1.3
  `terraform`-cli command
```
  terraform --version
```
- AWS-CLI 2.2.13
  `aws` cli command must be installed
```
  aws --version
```
- AWS Account required
  Access & Secret Key deployed in `~/.aws/credentials`
```
  aws 
```
- Docker
  `docker info`
  Docker Daemon must be running!

# Quotes
- The set of files used to **describe infrastructure in Terraform** is known as a "**Terraform configuration**". 
- Terraform is an infrastructure as code tool and claims itself as **the swizz army knife for cloud provider management**.

## Optional: IntelliJ AWS Plugin:
https://aws.amazon.com/de/intellij/

# Store AWS Credentials
Enter AWS service "Identity and Access Management (IAM)":
https://console.aws.amazon.com/iamv2/home?#/users
IAM > Users > your user > Sicherheitsanmeldeinformationen
Zugriffsschlüssel erstellen
> Zugriffsschlüssel-ID
> Geheimer Zugriffsschlüssel
In user dir `~/.aws/credentials`.

The AWS-CLI tool provides a **config & credentials wizard** for the 5 primary config fields:
```
aws configure
```

s. AWS Docs:
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

## Check AWS credentials
This command will check the calling identity and secret key and report errors if the credentials are not suitable:
```
aws sts get-caller-identity
```

---

# 3. Setup main.tf
This will describe our AWS EC2 instance:
```
./main.tf
```

# 4. Terraform init
Downloads required Terraform AWS plugins.
```
terraform init
```

# 5. Auto-Format all Terraform files
```
terraform fmt
```

# 6. Validate Terraform Configuration
```
terraform validate
```

# 7. Terraform apply
Apply Terraform Configuration
```
terraform apply
```
Terraform waits for the EC2 instance to become available.
This may take some minutes.

Your new instances will show up in the EC2 console:
https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Instances:

# 8. Show Terraform State Information
Show the current Terraform Configuration
```
terraform show
```

When Terraform created this EC2 instance, it gathered the resource's metadata from the AWS provider --
  and wrote it to the state file.

# 9. Project State
List Resources in your project's state:
```
terraform state list
```

# 10. Change Terraform Configuration
Infrastructure is continuously evolving and Terraform helps you to manage that change.
As you change Terraform configurations, Terraform builds an execution plan that only 
modifies what is necessary to reach your desired state.

The AMI (Amazon Machine Image) is changed in `main.tf` --
This changes the AMI from **ubuntu/images/hvm/ubuntu-precise-12.04-amd64-server-20170502**
to a **Ubuntu 16.04 AMI** machine.

# 11. Chekov - IaC Linter? - 'Policy as Code'
https://www.checkov.io/
Checkov scans cloud infrastructure configurations to find misconfigurations before they're deployed.

# 12. Terraform Apply
```
terraform apply
```
This will apply the changes: It will destroy the old AMI and create the new one.

The new configuration is shown with the `show` command:
```
terraform show
```

# 13. Destroying Infrastructure
This command is the inverse of `terraform apply`.
It does not destroy resources running elsewhere that are not managed by the current Terraform project.
```
terraform destroy
```

# 14. Input Variables
New file `variables.tf` added.

All `.tf` files are loaded by Terraform -- Naming is arbitrary.

# 15. Passing Variables via CLI
This overrides the file values.
```
terraform apply -var "instance_name=YetAnotherName"
```

# 16. Output Queries Values from AWS
Create file `outputs.tf`. Then apply this new configuration:
```
terraform apply
```
The 2 values are printed after config change was applied:
```
instance_id = "i-08b0823abc891faef"
instance_public_ip = "54.149.193.30"
```

The Terraform output command will just query and output the output values:
```
terraform output
``` 
Terraform outputs help to connect Terraform projects with other parts of your infrastructure,
or with other Terraform projects.

========================================================================================

# Single Steps for the "Terraform Docker PHP8 Laravel" Primer

Tutorial picked from:
https://medium.com/avmconsulting-blog/how-to-deploy-a-dockerised-node-js-application-on-aws-ecs-with-terraform-3e6bceb48785

See the commits:

# 1 - ECR Repository

# 2 - Create Docker Image

Can also be run locally - output should be visible after running the container:

```
docker build . --tag hello-js-app:14.18
docker images
docker run --detach --publish 5555:8181 --tty hello-js-app:14.18
http://localhost:5555/user
```

# 3 - Push Docker Image to ECR

# 4 - Add empty ECS Cluster

The ECS is a fully managed container orchestration service for running containers.

ECS has three parts: **clusters**, **services**, and **tasks**:
- **Tasks** are JSON files that describe how a container should be run.
  For example, you need to specify the ports and image location for your application.
- A **service** simply runs a specified number of tasks and restarts/kills them as needed.
  This has similarities to an auto-scaling group for EC2.
- A **cluster** is a logical grouping of **services** and **tasks**.

# 5 - Add ECS Task Definition

# 6 - Add ECS Service

# 7 - Add Network Security Group

# 8 - Add EC2 Instance + IAM instance profile + IAM role

# 9 - Add user-data field

# 10 - Second Container: nginx

### Destroy Terraform environment
This will remove the previously created Docker image and container. 
```
terraform destroy
```
Confirm with `yes` and `ENTER`.

# 11 - Third container: php-fpm


========================================================================================
 
### TODO add PHP-fpm Server + phpinfo/symfony?


# Terraform Primer

## Software Requirements
- Terraform 1.1.2
- AWS Account required (CreditCard required)

## Quotes
- "Infrastructure as Code"
- Infrastruktur ist genauso ein Artefakt wie der Quellcode meiner Anwendung
- Terraform plugins are called "**providers**"
- IaC tools allow you to manage infrastructure with configuration files rather than through a graphical UI
- "Die Größe meiner Cloud skaliert mit der Kreditkarte."
- Terraform's configuration language is **declarative** -
  it describes the desired end-state for your infrastructure and contains NO step-by-step instructions.
- "Terraform ist das Schweizer Taschenmesser der Cloud Infrastruktur"
- Terraform can be used with all major cloud providers.
  (AWS, Microsoft Azure, Google Cloud. Kubernetes, Oracle Cloud Infrastructure)

## Phases of Terraform Infrastructure Deployment
- **Scope** - Identify the infrastructure for your project.
- **Author** - Write the configuration for your infrastructure.
- **Initialize** - Install the plugins Terraform needs to manage the infrastructure.
- **Plan** - Preview the changes Terraform will make to match your configuration.
- **Apply** - Make the planned changes.

# Terraform AWS Tutorial
- https://learn.hashicorp.com/collections/terraform/aws-get-started

## 1. Install terraform
With Homebrew
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

## 2. Create AWS Credentials
Enter **AWS Identity and Access Management (IAM)**
- Create User + Access Key!
- Save in `~/.aws/credentials`:

```
[default]
aws_access_key_id=...
aws_secret_access_key=...
```

## 3. Create NGINX Server Hello World

### Install and Run Docker Desktop for macOS:
```
open -a Docker
```

### Create main.tf
Find the content inside this repository. `./main.tf`.

### Init Terraform 
This inits Terraform for the specified setup by downloading all required Terraform plugins --
The plugin ('provider') for Docker in our case ('kreuzwerker/docker').
```
terraform init
```

### Apply Terraform 
This will apply the specified Terraform structure.
```
terraform apply
```
Confirm with `yes` and `ENTER`.

### Test Terraform 
The new NGINX Docker image and container have now been created.
NGINX is running on:

```
http://localhost:8000/
```


## Local state file
Terraform is working with a local statefile.
`terraform.tfstate`
=> Da ja auch über die (AWS-)Web-Oberfläche Werte geändert werden können.

- Terraform keeps track of your real infrastructure in a **state file**,
  which acts as a **source of truth** for your environment.

- Terraform uses the state file to determine the changes to make to your infrastructure
  so that it will match your configuration.

## Terraform Import => Übernimmt Config von Web-Oberfläche
