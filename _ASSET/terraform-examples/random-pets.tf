
# pick and assign random pet names to variables
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet.html

resource "random_pet" "ec2_instance" {
}

resource "random_pet" "ecs_container_node_js" {
}

resource "random_pet" "ecr_task" {
}

# output random pet names

output "name_ec2_instance" {
    value = "${random_pet.ec2_instance.id}"
}

output "name_ecs_container_node_js" {
    value = "${random_pet.ecs_container_node_js.id}"
}

output "name_ecr_task" {
    value = "${random_pet.ecr_task.id}"
}
