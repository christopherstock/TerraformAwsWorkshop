resource "aws_ecr_repository" "workshop_ecr_repository_node" {
    name = "workshop_ecr_repository_node"

    // login to local Docker registry

    provisioner "local-exec" {
        command = "aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${aws_ecr_repository.workshop_ecr_repository_node.repository_url}"
        interpreter = ["bash", "-c"]
    }

    // build local Docker Image from Node.js-Dockerfile

    provisioner "local-exec" {
        command = "docker build -t workshop_ecr_repository_node -f ${path.module}/../Dockerfile-Node ${path.module}/../"
        interpreter = ["bash", "-c"]
    }

    // tag Docker Image
    provisioner "local-exec" {
        command = "docker tag workshop_ecr_repository_node:latest ${aws_ecr_repository.workshop_ecr_repository_node.repository_url}:latest"
        interpreter = ["bash", "-c"]
    }

    // push Docker Image to ECR
    provisioner "local-exec" {
        command = "docker push ${aws_ecr_repository.workshop_ecr_repository_node.repository_url}:latest"
        interpreter = ["bash", "-c"]
    }
}
