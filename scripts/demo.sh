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
  terraform -chdir="${INFRA_DIR}" destroy -auto-approve -var-file="${TFVARS_FILE}" >/dev/null || true
}

trap destroy EXIT

echo "Terraform init..."
terraform -chdir="${INFRA_DIR}" init -upgrade >/dev/null

echo "Terraform apply (temporary demo)..."
terraform -chdir="${INFRA_DIR}" apply -auto-approve -var-file="${TFVARS_FILE}"

IP="$(terraform -chdir="${INFRA_DIR}" output -raw public_ip)"
APP_URL="$(terraform -chdir="${INFRA_DIR}" output -raw app_url)"

echo "Public IP: ${IP}"
echo "App URL :  ${APP_URL}"

echo "Waiting for SSH to become ready..."
for i in {1..30}; do
  if ssh -i "${SSH_KEY}" \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      -o ConnectTimeout=5 \
      "${SSH_USER}@${IP}" "echo ssh-ok" >/dev/null 2>&1; then
    echo "SSH is ready."
    break
  fi
  sleep 5
  if [[ "${i}" -eq 30 ]]; then
    echo "ERROR: SSH not reachable after retries."
    exit 1
  fi
done

echo "Waiting for cloud-init and checking Docker + port 80..."
ssh -i "${SSH_KEY}" \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "${SSH_USER}@${IP}" \
  'cloud-init status --wait || true; sudo docker ps || true; sudo ss -lntp | grep ":80 " || true; sudo tail -n 60 /var/log/cloud-init-output.log || true'

echo "Curling the app (with retries)..."
for i in {1..20}; do
  if curl -fsS "${APP_URL}" >/dev/null 2>&1; then
    echo "App is reachable:"
    curl -fsS "${APP_URL}"
    echo
    exit 0
  fi
  sleep 5
done

echo "ERROR: App not reachable after retries."
exit 1
