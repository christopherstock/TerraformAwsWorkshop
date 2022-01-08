resource "aws_iam_role" "workshop_iam_role" {
    name = "workshop_iam_role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.workshop_iam_policy_document.json}"
}

data "aws_iam_policy_document" "workshop_iam_policy_document" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "workshop_iam_role_policy_attachment" {
    role = "${aws_iam_role.workshop_iam_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
