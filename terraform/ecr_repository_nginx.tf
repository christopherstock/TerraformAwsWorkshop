resource "aws_ecr_repository" "workshop_ecr_repository_nginx" {
    name = "workshop_ecr_repository_nginx"

    // build local Docker Image from Dockerfile

    provisioner "local-exec" {
        command = "docker build -t workshop_ecr_repository_nginx -f ${path.module}/../Dockerfile-nginx ${path.module}/../"
        interpreter = ["bash", "-c"]
    }

    // tag Docker Image
    provisioner "local-exec" {
        command = "docker tag workshop_ecr_repository_nginx:latest ${aws_ecr_repository.workshop_ecr_repository_nginx.repository_url}:latest"
        interpreter = ["bash", "-c"]
    }

    // push Docker Image to ECR
    provisioner "local-exec" {
        command = "docker push ${aws_ecr_repository.workshop_ecr_repository_nginx.repository_url}:latest"
        interpreter = ["bash", "-c"]
    }
}
