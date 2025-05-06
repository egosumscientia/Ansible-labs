#!/bin/bash

# Definir la estructura de directorios
dirs=(
  "ansible-azure-lab/terraform"
  "ansible-azure-lab/inventory"
  "ansible-azure-lab/group_vars"
  "ansible-azure-lab/host_vars"
  "ansible-azure-lab/files"
  "ansible-azure-lab/scripts"
)

# Definir los archivos a crear
files=(
  "ansible-azure-lab/terraform/main.tf"
  "ansible-azure-lab/terraform/variables.tf"
  "ansible-azure-lab/terraform/outputs.tf"
  "ansible-azure-lab/terraform/terraform.tfvars"
  "ansible-azure-lab/inventory/inventory.ini"
  "ansible-azure-lab/inventory/azure_rm.yml"
  "ansible-azure-lab/inventory/azure_rm.py"
  "ansible-azure-lab/group_vars/all.yml"
  "ansible-azure-lab/group_vars/web_servers.yml"
  "ansible-azure-lab/group_vars/db_servers.yml"
  "ansible-azure-lab/host_vars/vm1.yml"
  "ansible-azure-lab/host_vars/vm2.yml"
  "ansible-azure-lab/files/test.txt"
  "ansible-azure-lab/scripts/setup_environment.sh"
  "ansible-azure-lab/ansible.cfg"
  "ansible-azure-lab/README.md"
)

# Crear los directorios
for dir in "${dirs[@]}"; do
  mkdir -p "$dir"
done

# Crear los archivos vacíos
for file in "${files[@]}"; do
  touch "$file"
done

echo "Estructura del proyecto 'ansible-azure-lab' creada exitosamente."
