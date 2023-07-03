
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
# pick and show available AWS Availability Zones

data "aws_availability_zones" "az_available" {
  state = "available"
}

# output available AWS Availability Zones

output "availability_zones_available" {
    value = data.aws_availability_zones.az_available.names
}
