# Azure IaC App Platform (Terraform + Azure)

A small, production-shaped Infrastructure-as-Code project that provisions a secure Azure baseline:
**Resource Group + VNet/Subnet + NSG + Public IP + Linux VM**, and bootstraps a container via **cloud-init**.

## What this proves
- Terraform modules (network + compute)
- Azure networking basics (VNet/Subnet/NSG)
- Secure access pattern: SSH allowed only from *your* IP
- Reproducible workflows (plan/apply/destroy)
- CI quality gates (fmt + validate)

## Architecture
Internet
  └─ Public IP → NIC → Ubuntu VM
                 └─ NSG: allow 22 from your IP, allow 80 from anywhere
VNet (10.10.0.0/16)
  └─ Subnet (10.10.1.0/24)

## Prereqs
- Terraform
- Azure CLI
- Azure subscription access

## Quickstart
```bash
cd infra
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars:
# - location must be an allowed region for your subscription (some tenants restrict regions)
# - ssh_allowed_cidr = YOUR_PUBLIC_IP/32
# - ssh_public_key = your RSA public key line

terraform init
terraform plan
terraform apply

