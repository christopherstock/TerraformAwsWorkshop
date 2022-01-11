resource "aws_ecs_service" "workshop_ecs_service" {
    name            = "workshop_ecs_service"                          # Naming our first service
    cluster         = aws_ecs_cluster.workshop_ecs_cluster.id         # Referencing our created Cluster
    task_definition = aws_ecs_task_definition.workshop_ecs_task.arn   # Referencing the task our service will spin up
    desired_count   = 1                                               # number of task definitions to run
}
