resource "aws_ecr_repository" "workshop_ecr_repository_php" {
    name = "workshop_ecr_repository_php"
    force_delete = true

    // build local Docker Image from Dockerfile
    provisioner "local-exec" {
        command = "docker build -t workshop_ecr_repository_php -f ${path.module}/../Dockerfile-PHP ${path.module}/../"
        interpreter = ["bash", "-c"]
    }

    // tag Docker Image
    provisioner "local-exec" {
        command = "docker tag workshop_ecr_repository_php:latest ${aws_ecr_repository.workshop_ecr_repository_php.repository_url}:latest"
        interpreter = ["bash", "-c"]
    }

    // push Docker Image to ECR
    provisioner "local-exec" {
        command = "docker push ${aws_ecr_repository.workshop_ecr_repository_php.repository_url}:latest"
        interpreter = ["bash", "-c"]
    }
}
