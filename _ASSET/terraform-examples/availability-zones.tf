
# pick and show available and unavailable AWS Availability Zones
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones

data "aws_availability_zones" "az_available" {
  state = "available"
}

# output available and unavailable availability zones

output "availability_zones_available" {
    value = data.aws_availability_zones.az_available.names
}
