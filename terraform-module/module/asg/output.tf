output "Public_ip" {
  value = aws_launch_template.template_1.id
}
output "Private_ip" {
  value = aws_launch_template.template_2.id
}
