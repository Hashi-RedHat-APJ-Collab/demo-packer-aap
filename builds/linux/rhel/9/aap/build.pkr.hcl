locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")

  ansible_extra_arguments = var.debug_ansible ? [
    "--extra-vars", "role=${var.role}",
    "--extra-vars", "CONTROLLER_HOST='${var.controller_host}'",
    "--extra-vars", "CONTROLLER_USERNAME='${var.controller_username}'",
    "--extra-vars", "CONTROLLER_PASSWORD='${var.controller_password}'",
    "-vvv",
    "--scp-extra-args", "'-O'"

    ] : [
    "--extra-vars", "role=${var.role}",
    "--extra-vars", "CONTROLLER_HOST='${var.controller_host}'",
    "--extra-vars", "CONTROLLER_USERNAME='${var.controller_username}'",
    "--extra-vars", "CONTROLLER_PASSWORD='${var.controller_password}'",
    "--scp-extra-args", "'-O'"
  ]

}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

data "amazon-ami" "rhel9-ue1" {
  region = var.aws_region
  filters = {
    name                = "RHEL-9*-x86_64-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["309956199498"] # Red Hat
}

source "amazon-ebs" "rhel9" {
  ami_name       = "${var.ami_prefix}-${local.timestamp}"
  instance_type  = "m6a.xlarge"
  region         = var.aws_region
  source_ami     = data.amazon-ami.rhel9-ue1.id
  ssh_username   = "ec2-user"
  ssh_agent_auth = false
  #dont terminate on error
  delete_on_termination = false
}

build {
#   hcp_packer_registry {
#     bucket_name = "rhel9"
#     description = <<EOT
#     Ansible provsioner
#     EOT
#     bucket_labels = {
#       "owner" = "sa-apj-team"
#       "os"    = "RHEL"
#     }

#     build_labels = {
#       "build-time"   = timestamp()
#       "build-source" = basename(path.cwd)
#     }
#   }
  sources = [
    "source.amazon-ebs.rhel9"
  ]

  # First create the aap user and set up SSH
  provisioner "shell" {
    inline = [
      "sudo useradd -m -s /bin/bash aap",
      "echo 'aap ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/aap",
      "sudo chmod 0440 /etc/sudoers.d/aap",
      "sudo usermod -aG wheel aap",
      "sudo mkdir -p /home/aap/.ssh",
      "sudo chown -R aap:aap /home/aap/.ssh",
      "sudo chmod 700 /home/aap/.ssh",
      "echo '${var.ssh_public_key}' | sudo tee /home/aap/.ssh/authorized_keys",
      "sudo chown aap:aap /home/aap/.ssh/authorized_keys",
      "sudo chmod 600 /home/aap/.ssh/authorized_keys"
    ]
  }
  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbook.yml"
    use_sftp      = false
    galaxy_file   = "${path.cwd}/ansible/requirements.yml"
    user          = "aap"

    extra_arguments = local.ansible_extra_arguments

    ansible_env_vars = [
      "ANSIBLE_REMOTE_TMP=/tmp",
      "CONTROLLER_HOST=${var.controller_host}",
      "CONTROLLER_USERNAME=${var.controller_username}",
      "CONTROLLER_PASSWORD=${var.controller_password}"
    ]
  }

}
