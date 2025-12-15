output "vpc_id" {
    value = aws_vpc.my_vpc.id
}
output "Elastic_IP" {
    value = aws_eip.Elastic_IP
}