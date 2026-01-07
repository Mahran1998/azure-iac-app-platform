variable "name_prefix" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group" {
  type = string
}

variable "nic_id" {
  type = string
}

variable "admin_username" {
  type = string
}
variable "ssh_public_key" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "app_image" {
  type = string
}
