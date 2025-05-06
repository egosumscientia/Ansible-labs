#!/bin/bash

# Define la estructura del proyecto
mkdir -p Lab03/terraform
touch Lab03/terraform/main.tf
touch Lab03/terraform/variables.tf
touch Lab03/terraform/outputs.tf

mkdir -p Lab03/ansible
touch Lab03/ansible/inventory.ini
touch Lab03/ansible/playbook.yml

mkdir -p Lab03/ansible/group_vars
touch Lab03/ansible/group_vars/all.yml

mkdir -p Lab03/ansible/roles/system_info/tasks
touch Lab03/ansible/roles/system_info/tasks/main.yml

mkdir -p Lab03/ansible/roles/system_info/handlers
touch Lab03/ansible/roles/system_info/handlers/main.yml

mkdir -p Lab03/ansible/roles/system_info/templates
touch Lab03/ansible/roles/system_info/templates/info.j2

touch Lab03/README.md

echo "Estructura de proyecto creada exitosamente."
