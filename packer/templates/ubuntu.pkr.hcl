packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.2"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}
source "amazon-ebs" "ubuntu" {
  ami_name          = "ubuntu-ami-{{timestamp}}"
  access_key        = ""
  secret_key        = ""
  region            = "us-east-1"
  instance_type     = "t2.small"
  ssh_username      = "ubuntu"
  source_ami        = "ami-0e86e20dae9224db8"
  shutdown_behavior = "stop"
  tags = {
    "Name" = "ec2-AMI"
  }
  run_tags = {
    "Name" = "Packer-AMI"
  }
}
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  # Run the shell provisioner: start.sh to install ansible
  provisioner "shell" {
    script = "../scripts/start.sh"
  }
  # Run the ansible provisioner: playbook.yml to install nginx
  provisioner "ansible-local" {
    playbook_file = "../../ansible/playbook.yaml"
  }
  # Run the shell provisioner: clean.sh to clean the instance
  provisioner "shell" {
    script = "../scripts/clean.sh"
  }
}