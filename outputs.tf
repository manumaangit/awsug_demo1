output "ec2_public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.ec2_instance.*.public_ip
}

output "ec2_private_key" {
  description = "Private Key of the instance"
  sensitive = true
  value       = tls_private_key.terrafrom_generated_private_key.private_key_pem
}