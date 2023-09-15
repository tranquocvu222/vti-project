resource "aws_iam_policy" "iam_policy" {
  name        = var.policy_name
  description = var.policy_description
  policy = var.policy_rule
}