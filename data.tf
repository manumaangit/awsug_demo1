data "aws_instance" "new_instance" {
  instance_id = aws_instance.ec2_instance.id
}

