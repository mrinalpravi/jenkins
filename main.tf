resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.key_pair.private_key_pem
  filename        = "${path.module}/sre-key.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "sre-key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-085ad6ae776d8f09c"
  instance_type          = "t3.medium"
  associate_public_ip_address = true
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = ""
  subnet_id              = ""

  root_block_device {
    volume_size = 64
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo dnf upgrade -y
    sudo dnf install java-17-amazon-corretto -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo dnf install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
  EOF

}
