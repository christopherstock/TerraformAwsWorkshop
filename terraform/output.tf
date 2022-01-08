output "API_HOST" {
    value = "http://${aws_instance.workshop_ec2_instance.public_ip}"
}

output "CURL_TEST_COMMAND_NODE" {
    value = "curl -v 'http://${aws_instance.workshop_ec2_instance.public_ip}:5555/user'"
}
output "CURL_TEST_COMMAND_PHP" {
    value = "curl -v --header 'Accept: application/json' 'http://${aws_instance.workshop_ec2_instance.public_ip}:5556/api/v1/countries?name=Spain'"
}

output "PUBLIC_DNS" {
    value = "https://${aws_instance.workshop_ec2_instance.public_dns}"
}

output "URL_ECS_REPOSITORY_NODE" {
    value = "${aws_ecr_repository.workshop_ecr_repository_node.repository_url}"
}
output "URL_ECS_REPOSITORY_NGINX" {
    value = "${aws_ecr_repository.workshop_ecr_repository_nginx.repository_url}"
}
output "URL_REPOSITORY_PHP" {
    value = "${aws_ecr_repository.workshop_ecr_repository_php.repository_url}"
}
