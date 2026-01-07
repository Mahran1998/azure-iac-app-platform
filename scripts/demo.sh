#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INFRA_DIR="${ROOT_DIR}/infra"

TFVARS_FILE="${TFVARS_FILE:-${INFRA_DIR}/terraform.tfvars}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_rsa_azure}"
SSH_USER="${SSH_USER:-azureuser}"
KEEP="${KEEP:-0}" # set KEEP=1 to skip destroy (not recommended)

if [[ ! -f "${TFVARS_FILE}" ]]; then
  echo "ERROR: ${TFVARS_FILE} not found."
  echo "Create it from infra/terraform.tfvars.example:"
  echo "  cp infra/terraform.tfvars.example infra/terraform.tfvars"
  exit 1
fi

if [[ ! -f "${SSH_KEY}" ]]; then
  echo "ERROR: SSH key not found at ${SSH_KEY}"
  echo "Generate RSA key (Azure may require RSA):"
  echo '  ssh-keygen -t rsa -b 4096 -C "you@email" -f ~/.ssh/id_rsa_azure'
  exit 1
fi

destroy() {
  if [[ "${KEEP}" == "1" ]]; then
    echo "[KEEP=1] Skipping terraform destroy."
    return 0
  fi
  echo "Destroying resources to minimize cost..."
chmod +x scripts/demo.shchable after retries."henps || true; sudo ss -lntp | grep ":80 " || true; sudo tail -n 80 /var/log/cloud-init-ou
mahran@Eng-Mahran:~/Projects/azure-iac-app-platform$ cat > Makefile <<'EOF'
SHELL := /bin/bash

.PHONY: demo validate fmt

demo:
        ./scripts/demo.sh

validate:
        terraform fmt -check -recursive
        terraform -chdir=infra init -backend=false
        terraform -chdir=infra validate

fmt:
        terraform fmt -recursive
