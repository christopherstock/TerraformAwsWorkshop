# Terraform AWS Workshop

We'll setup a complete AWS Infrastructure for various Web Applications with Terraform.
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
- AWS Account required (CreditCard required)
  "Die Größe meiner Cloud skaliert mit meiner Kreditkarte"
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

# Einführung: Node.js Container Anwendung starten
Dockerfile-Node
```
# base image for this container
FROM node:14

# copy javascript source directory into the container
COPY application/js/* application/js/

# make container's port 8181 accessible to the outside
EXPOSE 8181

# run the app bundle with node
CMD [ "node", "application/js/express-8181.js" ]
```

Applikation:
```
application/js/express-8181.js
```

Das Docker Image kann auch lokal gebaut werden. Daraus kann dann ein Container instanziiert werden.

```
docker build . --tag express-js-app:14.18
docker images
docker run --detach --publish 5555:8181 --tty express-js-app:14.18
http://localhost:5555/user
```
Der interne Container-Port 8181 wird auf das Host-Betriebssystem auf Port 5555 gemappt.

Nachdem der Container gestartet wurde, steht die Node.js express Serveranwendung auf Port 5555 zur Verfügung:
```
http://localhost:5555
http://localhost:5555/user
```

Diese Docker-Container wollen wir nun auf den AWS Server pushen und somit die Node.js express Anwendung auf einer öffentlichen IP verfügbar machen.

---

# Create new Terraform Configuration
Terraform Dateien haben die Erweiterung `.tf`. Beim Ausführen eines Terraform-Befehls werden alle `.tf`-Dateien im aktuellen
  Verzeichnis eingelesen. Somit ist die Anzahl und Benamung aller Terraform-Dateien beliebig.
  Wir erstellen all unsere Terraform-Dateien in einem separaten Unterverzeichnis `terraform` unseres Projekts.
  Daher muss auch der Terraform-Befehl immer aus diesem Verzeichnis heraus aufgerufen werden!
- Terraform's configuration language is **declarative** -
  it describes the desired end-state for your infrastructure and contains NO step-by-step instructions.

---

## 1. terraform/provider.tf - Deklaration des Cloud Providers
Add `terraform/provider.tf`:
```
provider "aws" {
    region = "eu-central-1"
}
```
Download all required Terraform packages for this provider: 
```
terraform init
```
This inits Terraform for the specified setup by downloading all required Terraform plugins --
The plugin ('provider') for AWS and Docker in our case ('kreuzwerker/docker').
Downloads required Terraform AWS plugins.
```
terraform init
```

Terraform creates the lockfile `.terraform.lock.hcl` for tracking changes on the packages required by Terraform.
```
terraform apply
```
Applies the current configuration to the AWS Server.
As no resources has been specified so far, no resources are created.

On changing Terraform configurations, Terraform builds an execution plan that only 
modifies what is necessary to reach the desired state.

---

## 2. terraform/ecr_repository_node.tf - Deklaration eines ECR Repositories für den Node-Docker Container
Mit dem AWS Sercice ECR (Elastic Container Registry) können Docker Container-Images auf den AWS-Server gepusht
  und dort verwaltet werden.
Wir erstellen ein neues aber noch leeres AWS ECR Repository in den später ein Docker-Container gepusht werden kann.
  Wir vergeben die ID und den Namen `workshop_ecr_repository_node` für unser neues Repository.
Add `terraform/ecr_repository_node.tf`:
```
resource "aws_ecr_repository" "workshop_ecr_repository_node" {
    name = "workshop_ecr_repository_node"
}
```
Diese Änderungen wenden wir an. Diesmal müssen wir die skizziert angezeigten Änderungen explizit mit `yes` bestätigen.
```
terraform apply
```
Das neue Container-Repository wird im AWS Service **ECR** unter **Repositories** angezeigt:
![ECR > Repositories](_ASSET/screenshot/ecr_repositories.png)
Betritt man das Repository, so kann man über den Button **View Push Commands** die erforderlichen CLI-Befehle einsehen,
  um ein Docker Container-Image lokal zu bauen und in dieses AWS ECR Repository zu pushern.

Diese Befehle führen wir jetzt nicht manuell lokal aus sondern verbauen sie in unser Terraform-Skript:
Complete `terraform/ecr_repository_node.tf`.

Da diese `provisioner`-Schritte lediglich bei der Probisionierung, also dem initialen Setup des Repositories ausgeführt werden,
müssen wir die Terraform-Konfiguration explizit zerstören und erneut erstellen. Beide Befehle müssen mit `yes` bestätigt werden:
```
terraform destroy
terraform apply
```
Die Provisionierung dauert nun auch deutlich länger. Anschließend können wir unser neues Node.js-Container-Image
  in unserem Repository sehen:
![ECR > Node.js-Repository](_ASSET/screenshot/ecr_repository_node.png)

Unsere Node.js-Anwendung ist damit in einem Container-Image abgelegt und in der ECR registriert.

---
## 3. ECS Service

Mit dem AWS-Service **ECS** (Elastic Container Service) können nun Container von den registrierten Images
  instanziiert und gestartet werden.

The ECS is a fully managed container orchestration service for running containers.

Der ECS besteht aus drei Komponenten: **clusters**, **services**, and **tasks**:
- **Tasks** are JSON files that describe how a container should be run. Beispielsweise werden die Ports und Container Images angegeben. 
- A **service** simply runs a specified number of tasks and restarts/kills them as needed.
- A **cluster** is a logical grouping of **services** and **tasks**.

---

### 3.1. terraform/ecs_cluster.tf - Deklaration eines ECS Clusters
Create full `terraform/ecs_cluster.tf`.

```
terraform apply
```
Unser neu erstellter ECS Cluster wird im ECS Service angezeigt:
![ECS > Cluster](_ASSET/screenshot/ecs_cluster.png)

---

### 3.2. terraform/ecs_task_definition.tf - Add ECS Task Definition
Create first container task in `terraform/ecs_task_definition.tf`:

```
resource "aws_ecs_task_definition" "workshop_ecs_task" {
    family = "workshop_ecs_task"
    container_definitions = <<EOF
    [
        {
            "name": "node",
            "cpu": 128,
            "memory": 128,
            "image": "${aws_ecr_repository.workshop_ecr_repository_node.repository_url}",
            "essential": true,
            "portMappings": [
                {
                    "hostPort": 5555,
                    "protocol": "tcp",
                    "containerPort": 8181
                }
            ]
        }
    ]
    EOF
}
```
Angegeben wird die CPU u. RAM usage, das container image sowie das Port mapping.
Der Host-Port 5555 wird also umgemappt auf den Container-Port 8181 -- 
genau wie in unserem lokal durchgeführten Docker-Container-Beispiel.
```
terraform apply
```

Danach wird unsere neue Task-Definition im ECS unter **Aufgabendefinitionen** angezeigt:
![ECS > Aufgabendefinitionen](_ASSET/screenshot/ecs_task_definition.png)

---

### 3.3. terraform/ecs_service.tf - Add ECS Service
Nun erstellen wir den ECS Service und geben für den Service die zuletzt deklarierten ECS-Cluster und die
  deklarierte ECS-Taskdefinition an.
Add full `terraform/ecs_service.tf`.
```
terraform apply
```

Danach wurde der ECS Service erstellt und in unserem Workshop-Cluster `workshop_ecs_cluster` angelegt.
  Er kann hier in der Web-Oberfläche eingesehen werden:
![ECS > Cluster > workshop_ecs_cluster > Services](_ASSET/screenshot/ecs_service.png)

---

# 4. terraform/ecs_security_group.tf - Add Network Security Group
Allow incoming port 5555 on the host machine and propagation to port 5555 in our ECS service.
```
resource "aws_security_group" "workshop_ecs_security_group" {
    name = "workshop_ecs_security_group"

    ingress {
        from_port   = 5555 # allow traffic in from port 5555
        to_port     = 5555
        protocol    = "tcp" # allow ingoing tcp protocol
        cidr_blocks = ["0.0.0.0/0"] # allow traffic in from all sources
    }

    egress {
        from_port   = 0 # allow traffic out on all ports
        to_port     = 0
        protocol    = "-1" # allow any outgoing protocol
        cidr_blocks = ["0.0.0.0/0"] # allow traffic out from all sources
    }
}
```
Nach dem Durchführen von
```
terraform apply
```
ist die neue Sicherheitsgruppe erstellt.
Diese wird im AWS Service VPC (Virtual Private Cloud) erstellt:
VPC > Sicherheit > Sicherheitsgruppen
![VPC > Sicherheit > Sicherheitsgruppen](_ASSET/screenshot/ecs_security_group.png)

---

# 5. IAM instance profile + IAM role
Im Service AWS IAM (Identity and Access Management) muss ein Profil für unsere EC2-Instanz erstellt werden.
Hierfür muss auch eine IAM Role erstellt werden. 
Add files `terraform/iam_instance_profile.tf` and `terraform/iam_role.tf`.
```
terraform apply
```
Anschließend wird das neue IAM Instance Profile und die neue IAM Role in der Weboberfläche angezeigt:
![IAM > Zugriffsverwaltung > Rollen](_ASSET/screenshot/iam_role.png)

Das **Instance-Profile** kann nicht über die Web-Oberfläche verwaltet werden sondern lediglich über Terraform bzw. über den AWS CLI-Client.

---

# 6. Add EC2 Instance
Nun haben wir alle Services beisammen die wir zum Betrieb unseres Containers benötigen.
Da diese auch eine Maschine/Serverinstanz benötigen, erstellen wir als letztes eine EC2 Instanz
mit Hilfe des AWS Services **EC2** (Elastic Compute Cloud).

Alle zur Verfügung stehenden EC2 Instanztypen (AMI = Amazon Machine Image) finden Sie unter
`EC2 > Abbilder > AMI Catalog`.

The next Terraform file will describe our **AWS EC2** instance:
```
terraform/ec2_instance.tf
```
Das Feld `user_data` definiert ein Shell-Skript, das beim Startend der Maschine ausgeführt wird.
Hier ist es erforderlich, den Namen unseres ECS-Clusters in die ECS-Configdatei `/etc/ecs/ecs.config` zu schreiben.
```
terraform apply
```
Unsere neue EC2-Instanz wird anschließend im AWS EC2 service angezeigt:
![EC2 > Instances > Instances](_ASSET/screenshot/ec2_instance.png)

Die `public IP` der EC2-Instanz kann hier ausgelesen werden.
  Mit einem cURL können wir nun die Node.js-Express-Anwendung in unserem Container erreichen:
```
curl -v 54.93.205.216:5555/
```









# 7. Output Queries Values from AWS
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


# 9. Second Container: nginx

### Destroy Terraform environment
This will remove the previously created Docker image and container. 
```
terraform destroy
```
Confirm with `yes` and `ENTER`.

# 10. Third container: php-fpm





---

# More Terraform Commands

## Auto-Format all Terraform files
```
terraform fmt
```

## Show Configuration change plan without apply (dry run)
```
terraform plan
```

## Validate current Terraform Configuration
```
terraform validate
```

## Show current Terraform State Configuration
```
terraform show
```

## List all Resources in your project's state:
```
terraform state list
```

---

# Further Reading

## Input Variables
New file `variables.tf` added.

All `.tf` files are loaded by Terraform -- Naming is arbitrary.

## Passing Variables via CLI
This overrides the file values.
```
terraform apply -var "instance_name=YetAnotherName"
```

## Local state file
Terraform is working with a local statefile.
`terraform.tfstate`
=> Da ja auch über die (AWS-)Web-Oberfläche Werte geändert werden können.

- Terraform keeps track of your real infrastructure in a **state file**,
  which acts as a **source of truth** for your environment.

- Terraform uses the state file to determine the changes to make to your infrastructure
  so that it will match your configuration.

## Terraform Import
Terraform kann auch die aktuelle Config aus der AWS Web-Oberfläche auslesen und in einer lokalen Terraform-Konfiguration ablegen.
```
testcode?
```

# Terraform rocks!

## Quotes
"Infrastructure as Code" is just right for developers:
  Infrastruktur ist genauso ein Artefakt wie der Quellcode meiner Anwendung
Terraform has a good developer experience.

- IaC tools allow you to manage infrastructure with configuration files rather than through a graphical UI
- "Die Größe meiner Cloud skaliert mit der Kreditkarte."
- "Terraform ist das Schweizer Taschenmesser der Cloud Infrastruktur"
- Terraform can be used with all major cloud providers.
  (AWS, Microsoft Azure, Google Cloud. Kubernetes, Oracle Cloud Infrastructure)
