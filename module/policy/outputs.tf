output "iam_instance_profile" {
  value = aws_iam_instance_profile.webaccess_profile.id

}
output "iam_arn" {
  value = aws_iam_instance_profile.webaccess_profile.arn
}

output "iam_role_arn" {
  value = aws_iam_role.webaccess_role.arn
}
output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.webaccess_profile.arn
}