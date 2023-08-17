resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_security_group" "ssh-sec-grp" {
  name        = "ssh-sec-grp-tf1"
  description = "Allow SSH traffic via Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_key_pair" "generated_key" {

  # Name of key: Write the custom name of your key
  key_name = "aws_keys_pairs-tf1"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory 
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem
      chmod 400 aws_keys_pairs.pem
    EOT
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "EC2_ECR_DockerPull"
}

resource "aws_instance" "ec2_instance" {
  ami                    = "ami-053b0d53c279acc90" # Change this to the correct Ubuntu 20.04 AMI ID
  instance_type          = "t2.micro"              # Change to the desired instance type
  key_name               = "aws_keys_pairs-tf1"    # Change to your key pair name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.ssh-sec-grp.id]
  tags = {
    Name = "Ubuntu-Docker-Instance=tf"
  }
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"

    # Mention the exact private key name which will be generated 
    private_key = file("aws_keys_pairs.pem")
    timeout     = "4m"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo usermod -aG docker ubuntu
              sudo apt install amazon-ecr-credential-helper
              mkdir -p ~/.docker
              echo '{
	            "credsStore": "ecr-login"
              }' > ~/.docker/config.json
              sudo docker run -p 3000:3000 644107485976.dkr.ecr.us-east-1.amazonaws.com/nodeapp:latest
              EOF
}
