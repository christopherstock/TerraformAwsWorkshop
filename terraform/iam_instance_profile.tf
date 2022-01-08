resource "aws_iam_instance_profile" "workshop_iam_instance_profile" {
    name = "workshop_iam_instance_profile"
    path = "/"
    role = "${aws_iam_role.workshop_iam_role.name}"
}
