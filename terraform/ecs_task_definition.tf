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
        },
        {
            "name": "nginx",
            "cpu": 128,
            "memory": 128,
            "image": "${aws_ecr_repository.workshop_ecr_repository_nginx.repository_url}",
            "essential": true,
            "links": [
                "php:php"
            ],
            "portMappings": [
                {
                    "hostPort": 5556,
                    "protocol": "tcp",
                    "containerPort": 80
                }
            ]
        },
        {
            "name": "php",
            "cpu": 128,
            "memory": 128,
            "image": "${aws_ecr_repository.workshop_ecr_repository_php.repository_url}",
            "essential": true
        }
    ]
    EOF
}
