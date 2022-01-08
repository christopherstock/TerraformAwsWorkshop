resource "aws_security_group" "workshop_ecs_security_group" {
    name = "workshop_ecs_security_group"

    ingress {
        from_port   = 5555 # allow traffic in from port 5555
        to_port     = 5555
        protocol    = "tcp" # allow ingoing tcp protocol
        cidr_blocks = ["0.0.0.0/0"] # allow traffic in from all sources
    }

    ingress {
        from_port   = 5556 # allow traffic in from port 5556
        to_port     = 5556
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
