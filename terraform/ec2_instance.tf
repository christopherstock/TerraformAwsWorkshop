resource "aws_instance" "workshop_ec2_instance" {
    ami                  = "ami-67cbd003"
    instance_type        = "t3.micro"
    security_groups      = ["${aws_security_group.workshop_ecs_security_group.name}"]
    iam_instance_profile = "${aws_iam_instance_profile.workshop_iam_instance_profile.name}"
    user_data            = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.workshop_ecs_cluster.name} > /etc/ecs/ecs.config
EOF
    tags = {
        Name = "workshop_ec2_instance"
    }
}
