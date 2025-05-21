variable "controller_host" {
  type    = string
  default = env("CONTROLLER_HOST")
}

variable "controller_username" {
  type    = string
  default = env("CONTROLLER_USERNAME")
}

variable "controller_password" {
  type    = string
  default = env("CONTROLLER_PASSWORD")
}

variable "ami_prefix" {
  type    = string
  default = "aaplab"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "os_username" {
  type    = string
  default = "ec2-user"
}

# variable "os_password" {
#   type = string
#   default = env("LINUX_PASSWORD")
# }

variable "debug_ansible" {
  type    = bool
  default = false
}

variable "role" {
  type        = string
  description = "The Ansible roles to trigger as part of the build process."
  default     = "aap"
}

# variable "role_config" {
#   type    = string
#   default = env("ROLE_CONFIG")
# }