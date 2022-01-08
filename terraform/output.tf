output "API_HOST" {
    value = "http://${aws_instance.workshop_ec2_instance.public_ip}"
}

output "PUBLIC_DNS" {
    value = "https://${aws_instance.workshop_ec2_instance.public_dns}"
}

output "URL_REPOSITORY_NODE" {
    value = "${aws_ecr_repository.workshop_ecr_repository_node.repository_url}"
}

output "CURL_TEST_COMMAND_NODE" {
    value = "curl -v 'http://${aws_instance.workshop_ec2_instance.public_ip}:5555/user'"
}
