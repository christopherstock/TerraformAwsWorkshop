# Terraform AWS Workshop

We'll setup a complete AWS Infrastructure for various Web Applications with Terraform.
It sets up a Terraform configuration for defining one single **AWS EC2 instance**.
This EC2 instance shall run three Docker container using **AWS ECS**.
The containers run on different ports of the EC2 instance and contain various web applications in Node.js,
HTML, JS and PHP.

# Software Requirements
- Terraform 1.1.3
- AWS-CLI 2.2.13
- Docker - Docker Daemon must be running
- AWS Account required and set up
