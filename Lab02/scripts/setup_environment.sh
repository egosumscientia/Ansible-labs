#!/bin/bash

# Instalar dependencias
sudo apt-get update
sudo apt-get install -y python3-pip git

# Instalar Ansible y Azure modules
pip3 install ansible
pip3 install ansible[azure]

# Descargar plugin de inventario dinámico
wget https://raw.githubusercontent.com/ansible-collections/azure/dev/plugins/inventory/azure_rm.py -O inventory/azure_rm.py
chmod +x inventory/azure_rm.py

# Configurar credenciales de Azure (simplificado - en producción usar Azure Key Vault)
mkdir -p ~/.azure
cat > ~/.azure/credentials <<EOF
[default]
subscription_id=${AZURE_SUBSCRIPTION_ID}
client_id=${AZURE_CLIENT_ID}
secret=${AZURE_CLIENT_SECRET}
tenant=${AZURE_TENANT_ID}
EOF

# Configurar ansible.cfg
cat > ansible.cfg <<EOF
[defaults]
inventory = ./inventory
host_key_checking = False
retry_files_enabled = False
EOF