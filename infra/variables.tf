variable "name_prefix" {
  type    = string
  default = "azure-iac"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "Your public IP in CIDR (e.g., 1.2.3.4/32) allowed to SSH"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key contents (full line)"
}

variable "app_image" {
  type        = string
  description = "Container image to run on the VM"
  default     = "nginxdemos/hello:plain-text"
}
