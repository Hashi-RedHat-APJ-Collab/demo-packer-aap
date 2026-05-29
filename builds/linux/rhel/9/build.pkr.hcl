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

# Use the RHEL9-SOE hardened base image from HCP Packer Registry
data "hcp-packer-artifact" "rhel9-soe" {
  bucket_name  = "RHEL9-SOE"
  platform     = "aws"
  region       = var.aws_region
  channel_name = "latest"
}

source "amazon-ebs" "rhel9" {
  ami_name       = "${var.ami_prefix}-${local.timestamp}"
  instance_type  = "m6a.2xlarge"
  region         = var.aws_region
  source_ami     = data.hcp-packer-artifact.rhel9-soe.external_identifier
  ssh_username   = "ec2-user"
  ssh_agent_auth = false
  ami_users      = var.ami_users

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 60
    volume_type           = "gp3"
    delete_on_termination = true
  }
  
  ssh_timeout         = "2h"
}

 

build {
  hcp_packer_registry {
    bucket_name = "RHEL9-AAP"
    description = "RHEL9 AAP controller image built on RHEL9-SOE base"
    bucket_labels = {
      "owner" = "glimpsovstar"
      "os"    = "RHEL"
      "role"  = "aap-controller"
    }
    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
      "base-image"   = data.hcp-packer-artifact.rhel9-soe.external_identifier
    }
  }
  sources = [
    "source.amazon-ebs.rhel9"
  ]

  provisioner "shell" {
    inline = [
      "sleep 5",
      "df -h",
      "df -h /"
    ]
  }

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbook.yml"
    use_sftp      = false
    galaxy_file   = "${path.cwd}/ansible/requirements.yml"
    user          = var.os_username

    extra_arguments = local.ansible_extra_arguments

    ansible_env_vars = [
      "ANSIBLE_REMOTE_TMP=/tmp",
      "CONTROLLER_HOST=${var.controller_host}",
      "CONTROLLER_USERNAME=${var.controller_username}",
      "CONTROLLER_PASSWORD=${var.controller_password}"
    ]
    
    timeout = "2h"
  }

}
