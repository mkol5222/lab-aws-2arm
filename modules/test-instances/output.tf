output "instance_ids" {
  value = { for az, instance in aws_instance.test_instances : az => instance.id }
}

output "private_ips" {
  value = { for az, instance in aws_instance.test_instances : az => instance.private_ip }
}